class AnalysisController < ApplicationController
  def analysis 
    @anals = Analysi.all
  end
end
