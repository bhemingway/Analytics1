class DataFile < ActiveRecord::Base
  # attr_accessible :title, :body
  validates :datafile, :presence => true

  def self.save(upload)
    if (upload.nil?)
      'no file to upload'
    else
      name =  upload['datafile'].original_filename
      directory = "public/data"
      # create the file path
      path = File.join(directory, name)
      # write the file
      File.open(path, "wb") { |f| f.write(upload['datafile'].read) }

      # return the local file name
      path
    end
  end
end
