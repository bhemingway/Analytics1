class UploadsController < ApplicationController
  def index
     #render :file => 'app\views\upload\uploadfile.rhtml'
  end

  # for prototype, file has to contail the character zero to be valid
  def validateUpload(file)
    # is this a text file?
    filetype = `file #{file}`
    if filetype.include? "ASCII"
      # assume "validity test failed"
      status = 2

      # process every line in a text file with ruby (version 1).
      inrecs = 0
      outrecs = 0
      dupes = 0
      f = File.open(file, "r")
      f.each_line { |line|
	  inrecs = inrecs + 1
          if line.count('0') > 0
	    status = 0
	  end
	  outrecs = outrecs + 1
      }
      f.close
    else
      # 1 is "unexpected file type"
      status = 1 
    end

    # now that we are done with the file, delete it
    File.delete(file)

    # return the status to the caller
    return status, inrecs, outrecs, dupes
  end

  def create
    # get the file from the user's machine
    localfile = DataFile.save(params[:upload])
    
    # now validate this file, setting "fileUploadStatus" global variable
    status,inrecs,outrecs,duperecs = validateUpload(localfile) 
    if status.zero?
      fileUploadStatus = t('upload_page.upload_ack_text') 
    else
      fileUploadStatus = t('upload_page.upload_nack_text') 
    end

    if inrecs.nil?
      inrecs = 0
    end
    if outrecs.nil?
      outrecs = 0
    end

    # figure out the current time in db-compatible format
    now = Time.new
    nowsql = sprintf("%04d-%02d-%02d %02d:%02d:%02d",now.year,now.month,now.day,now.hour,now.min,now.sec)
    fname = File.basename(localfile)

    # update the database
    sql = "INSERT INTO logs(filename,created_at,updated_at,comment,status,inrecs,outrecs,duperecs) VALUES('"
    sql << fname
    sql << "','" 
    sql << nowsql
    sql << "','"
    sql << nowsql
    sql << "','" 
    sql << params['log']['comment']
    sql << "','" 
    sql << fileUploadStatus
    sql << "',"
    sql << inrecs.to_s
    sql << "," 
    sql << outrecs.to_s
    sql << "," 
    sql << duperecs.to_s
    sql << ")"

    logger.debug sql
    ActiveRecord::Base.connection.execute(sql)

    # put the status where the index page can find it
    fileUploadStatus = fileUploadStatus + ': ' + fname + ' [' + status.to_s + ']'
    flash[:status] = fileUploadStatus

    # now show them what happened
    render 'index'
  end
end
