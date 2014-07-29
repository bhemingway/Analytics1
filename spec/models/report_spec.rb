require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
 
describe Report do
  before(:each) do
    @report = Report.new(:period => 'Testing Report model', :report => 1)
  end
  
  it "should be valid when new" do
    @report.should be_valid
  end
end
