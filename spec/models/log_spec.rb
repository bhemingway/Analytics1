require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
 
describe Log do
  before(:each) do
    @log = Log.new(:comment => 'Testing Log model', :filename => 'not-a-file', :status => 'Seems ok')
  end
  
  it "should be valid when new" do
    @log.should be_valid
  end
end
