class UploadsController < ApplicationController
  def index
    #render :file => 'app\views\upload\uploadfile.rhtml'

    # need this for history in index page
    @logs = Log.all
  end

  # for prototype, file has to contail the character zero to be valid
  def validateUpload(file)
    require 'nokogiri'
    require 'active_support/core_ext/hash/conversions'

    # is this a structured text file we can parse?
    filetype = `file #{file}`
    if filetype.include? "XML" or filetype.include? "HTML"
      # assume "validity test failed"
      status = 2

      # attributes to return
      inrecs = 0
      outrecs = 0
      duperecs = 0
      fcdt = nil
      hashalg = nil

      # get the contents of the file, presumed to be an XML doc
      f = File.open(file, "r")
      xml_doc = Nokogiri::XML(f)
      f.close

      # parse the XML doc
      h0 = Hash.from_xml(xml_doc.to_s)
      logger.debug h0.inspect

      # reach deep into the parsed XML tree because we want the header information
      header = h0['voterTransactionLog']['header']
      logger.debug "VTL header record: #{header.inspect}"
      if header.has_key?("createDate")
        fcdt = header['createDate']
      end
      if header.has_key?("hashAlg")
	hashalg = header['hashAlg']
      end

      # level 0 is the list of document types: should be just one, voterTransactionLog
      h0.keys.each do |doctype|
	logger.debug "parse XML level 0 key=#{doctype}"

	# level 1 is the list of record types: should be just two, header & voterTransactionRecord
	h1 = h0[doctype]
	h1.keys.each do |rectype| 

	  logger.debug "parse XML level 1 rec=#{rectype}"

	  # handle each record type as needed
	  recs = h1[rectype]

	  if rectype.include? "voterTransactionRecord"
	    #logger.debug "VTR records: #{recs.inspect}"
	    recs.each do |rec|
	      # count this input record
	      inrecs += 1

	      # get the hashing algorithm, which actually comes from the header
	      rec['hashAlg'] = hashalg

	      # check for an exact duplicate already in the database by creating a condition clause that matches exactly
	      conds = Hash.new
	      rec.each do |col, val|
		  conds[col] = val
	      end
	      logger.debug "De-dupe conditions: #{conds.inspect}"
	      dupes = Vtr.find(:all,
		:select => "voterid",
	        :conditions => conds
	      )
	      logger.debug dupes.inspect

	      # create if not a dupe
	      if dupes.count == 0
	      	Vtr.create(rec)
		outrecs += 1
	      else
	        duperecs += 1
	      end
	    end
	  end
        end
      end
      status = 0
    else
      # 1 is "unexpected file type"
      status = 1 
    end

    # now that we are done with the file, delete it
    File.delete(file)

    # return the status to the caller
    return status, inrecs, outrecs, duperecs, fcdt, hashalg
  end

  def create
    # get the file from the user's machine
    localfile = DataFile.save(params[:upload])
    
    # now validate this file, setting "fileUploadStatus" global variable
    status,inrecs,outrecs,duperecs,fcdt,hashalg = validateUpload(localfile) 
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
    if duperecs.nil?
      duperecs = 0
    end

    # figure out the current time in db-compatible format
    now = Time.new
    nowsql = sprintf("%04d-%02d-%02d %02d:%02d:%02d",now.year,now.month,now.day,now.hour,now.min,now.sec)
    fname = File.basename(localfile)

    # set up the DB update by creating a hash (hoping for quoting and SQL safety)
    rec = Hash.new();
    rec['filename'] = fname;
#    rec['created_at'] = nowsql;
#    rec['updated_at'] = nowsql;
    rec['comment'] = params['log']['comment']
    rec['status'] = fileUploadStatus
    rec['inrecs'] = inrecs
    rec['outrecs'] = outrecs
    rec['duperecs'] = duperecs
    rec['fileCreateDate'] = fcdt

    # update the database
    Log.create(rec)

    # put the status where the index page can find it
    fileUploadStatus = fileUploadStatus + ': ' + fname + ' [' + status.to_s + ']'
    flash[:status] = fileUploadStatus

    # need this for history in index page
    @logs = Log.all

    # now show them what happened
    render 'index'
  end
end
