class Period < ActiveRecord::Base
  attr_accessible :hidate, :lodate, :name, :ptype, :voter_reg_hidate, :voter_reg_lodate

  validates_presence_of :name
  validates_presence_of :ptype
  validates_presence_of :lodate

  # globals for dealing with ptype
  P2string = {1 => 'Election Reporting Period', 2 => 'Custom Reporting Period'}
  String2p = [
               ['Election Reporting Period', 1],
	       ['Custom Reporting Period',2]
             ]
end
