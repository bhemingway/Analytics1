module ApplicationHelper
  # show the user which files have already been uploaded
  def listFiles
      rtn = "<ol>"
      Dir.glob("/var/www/Analytics1/public/data/*") do |data_file|
	  fn = File.basename(data_file)
          rtn = rtn + "<li> #{fn}</li>"
      end
      rtn = rtn + "</ol>"

      rtn
  end
end
