class ReportsController < ApplicationController
  def reports 
    @rpts = Report.all
  end
end
