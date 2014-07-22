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
      inrecs = 0		# count input records
      outrecs = 0		# count output records
      duperecs = 0		# count duplicate records (not output)
      fcdt = nil		# the file creation date time
      hashalg = nil		# the voter ID hashing algorithm
      vids = Hash.new()		# count unique voter ids
      events = Hash.new()	# count each event type
      lodate = hidate = nil	# track earliest and latest date

      # get the contents of the file, presumed to be an XML doc
      f = File.open(file, "r")
      xml_doc = Nokogiri::XML(f)
      f.close

      # parse the XML doc
      h0 = Hash.from_xml(xml_doc.to_s)
#      logger.debug h0.inspect

      # reach deep into the parsed XML tree because we want the header information
      header = h0['voterTransactionLog']['header']
#      logger.debug "VTL header record: #{header.inspect}"
      if header.has_key?("createDate")
        fcdt = header['createDate']
      end
      if header.has_key?("hashAlg")
	hashalg = header['hashAlg']
      end

      # level 0 is the list of document types: should be just one, voterTransactionLog
      h0.keys.each do |doctype|
#	logger.debug "parse XML level 0 key=#{doctype}"

	# level 1 is the list of record types: should be just two, header & voterTransactionRecord
	h1 = h0[doctype]
	h1.keys.each do |rectype| 
#	  logger.debug "parse XML level 1 rec=#{rectype}"

	  # handle each record type as needed
	  recs = h1[rectype]

	  if rectype.include? "voterTransactionRecord"
#	    logger.debug "VTR records: #{recs.inspect}"
	    recs.each do |rec|
	      # count this input record
	      inrecs += 1

	      # get the hashing algorithm, which actually comes from the header
	      rec['hashAlg'] = hashalg

	      # check for missing time offset, default to zero (UTC)
	      tz = /\s*[\-\+]\d{1,2}\:\d{1,2}\s*$/.match(rec['date'])
	      logger.debug "Time zone match: " + tz.inspect
	      if tz.nil?
	        rec['date'] += "+00:00"
	      end

	      # check for an exact duplicate already in the database by creating a condition clause that matches exactly
	      conds = Hash.new
	      rec.each do |col, val|
		  next if col == 'date'	# deal with date column separately (why do I have to do this?)
		  conds[col] = val
	      end
#	      logger.debug "De-dupe conditions: #{conds.inspect}"
#	      dupes = Vtr.find(:all,
#		:select => "voterid",
#	        :conditions => conds
#	      )
	      dupes = Vtr.where(conds).all
	      logger.debug "POSSIBLE DUPES: " + dupes.inspect

	      # check time stamp separately
	      isok = 1
	      if dupes.count > 0
		logger.debug "De-dupe incoming date is '" + rec['date'] + "'"
		t1 = rec['date'].to_time.strftime("%m/%d/%Y %I:%T.%3N")
		logger.debug "De-dupe incoming date as a string: '" + t1 + "'"
	        dupes.each do |dupe|
		  t2 = dupe['date'].to_time.strftime("%m/%d/%Y %I:%T.%3N")
		  logger.debug "De-dupe existing db date as a string: '" + t2 + "'"
		  if t1 == t2
		    isok = 0
		    logger.debug "ACTUAL DUPE: " + t2
		    break
		  end
		end
	      end

	      # create if not a dupe
	      if dupes.count == 0 or isok == 1

		# keep stats about this batch
		outrecs += 1
		k = rec['voterid']
		k = '(blank)' if k.nil? or k.empty?
		vids[k] = 0 if vids[k].nil?
		vids[k] += 1
		k = rec['action']
		k = '(blank)' if k.nil? or k.empty?
		events[k] = 0 if events[k].nil?
		events[k] += 1
		if lodate.nil?
		  lodate = hidate = rec['date']
		end
		rc = (rec['date'] <=> lodate)
		lodate = rec['date'] if rc < 0
		rc = (rec['date'] <=> hidate)
		hidate = rec['date'] if rc > 0

		# save the incoming record
	      	Vtr.create(rec)
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

    # some of the "stats" require pre-processing
    eventString = ''
    events.each do |key, val|
      eventString += key		# key
      eventString += '<>'		# key val separator
      eventString += val.to_s		# val
      eventString += '^'		# key pair separator
    end

    logger.debug "Events: " + events.inspect
    logger.debug "Event string: " + eventString

    # return the status to the caller
    return status, inrecs, outrecs, duperecs, fcdt, hashalg, lodate, hidate, vids.count(), eventString
  end

  def create
    # get the file from the user's machine
    localfile = DataFile.save(params[:upload])
    
    # now validate this file, setting "fileUploadStatus" global variable
    status,inrecs,outrecs,duperecs,fcdt,hashalg,lodate,hidate,vidcount,events = validateUpload(localfile) 
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
    rec['lowdate'] = lodate
    rec['highdate'] = hidate
    rec['idcount'] = vidcount
    rec['eventfreqs'] = events

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
