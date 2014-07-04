class Report < ActiveRecord::Base
  attr_accessible :period, :report

  validates_presence_of :report
  validates_presence_of :period

  # global for dealing with reports
  Pnames = [] # will be filled-in at render time
  R2string = [1,'EAC Survey']
  String2r = [
               ['EAC Survey', 1]
             ]
end
