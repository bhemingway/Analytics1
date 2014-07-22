class Log < ActiveRecord::Base
  attr_accessible :comment, :duperecs, :inrecs, :outrecs, :status, :filename, :fileCreateDate, :lowdate, :highdate, :idcount, :eventfreqs
  validates_presence_of :comment
  validates_presence_of :filename
end
