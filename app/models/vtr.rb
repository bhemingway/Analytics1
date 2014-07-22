class Vtr < ActiveRecord::Base
  attr_accessible :action, :comment, :date, :election, :form, :formNote, :jurisdiction, :leo, :notes, :voterid, :hashAlg
  def self.search(search)
    if search
      find(:all, :conditions => ['voterid LIKE ?', "%#{search}%"])
    else
      find(:all)
    end
  end
end
