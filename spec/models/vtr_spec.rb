require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
 
describe Vtr do
  before(:each) do
    @vtr = Vtr.new(:comment => 'Testing Rproc model', :voterid => 'US-BFH-1')
  end
  
  it "should be valid when new" do
    @vtr.should be_valid
  end
end
