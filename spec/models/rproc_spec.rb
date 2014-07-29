require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
 
describe Rproc do
  before(:each) do
    @rproc = Rproc.new(:name => 'Testing Rproc model', :description => 'not blank')
  end
  
  it "should be valid when new" do
    @rproc.should be_valid
  end
end
