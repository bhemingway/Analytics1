class ReportPeriodsController < ApplicationController
  def report_period 
    @rptpds = ReportPeriod.all
  end
end
