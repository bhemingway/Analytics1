module ReportsHelper

  # GenRept is a simple dispatch routine, calling report generation based on ID
  def GenRept(report)
    # parameter is a report job description
    rproc_id = report.report
    period_name = report.period

    # expand period name into parameters
    period = Hash.new()
    @periods.each do |tmp|
      if tmp.name == period_name
	period['ptype'] = tmp.ptype
	period['lodate'] = tmp.lodate
	period['hidate'] = tmp.hidate
	period['voter_reg_lodate'] = tmp.voter_reg_lodate
	period['voter_req_hidate'] = tmp.voter_reg_hidate
	break
      end
    end

    retval = ''

    # case maps rproc IDs to code to implement that reprot
    case rproc_id
    when 1
      retval = DoR1(period)
    when 2
      retval = DoR2(period)
    else
      retval = 'Rproc #{rproc_id} is not supported'   	
    end

    retval
  end

  #
  # these functions implement the reports
  #

  def DoR1(period)
    retval = '' # what we return
    accum = Hash.new() # where we accumulate data to report

    # get a list of VTRs between these dates and make a hash of the formNote
    rows = Vtr.where("date(date) between ? and ?", period['lodate'].to_s(:db), period['hidate'].to_s(:db))
    rows.each do |row|
      k = row['formNote']
      accum[k] = 0 if accum[k].nil?
      accum[k] += 1
    end

    retval = accum.inspect
  end

  def DoR2(period)
    retval = '' # what we return
    accum = Hash.new() # where we accumulate data to report

    # get a list of VTRs between these dates and count transactions by voter id
    rows = Vtr.where("date(date) between ? and ?", period['lodate'].to_s(:db), period['hidate'].to_s(:db))
    rows.each do |row|
      k = row['voterid']
      accum[k] = 0 if accum[k].nil?
      accum[k] += 1
    end

    # scan accumulator, get the min, max and average
    tot = count = 0
    min = max = nil
    accum.each do |k,v|
      # handle initialization
      min = v if min.nil?
      max = v if max.nil?

      tot += v
      count += 1

      min = v if (v < min)
      max = v if (v > max)
    end
    avg = tot / count if count > 0

    retval = "Tranactions per voter: min=#{min} max=#{max} average=#{avg}"
  end

end
