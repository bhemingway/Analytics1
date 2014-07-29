require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
 
describe Period do
  before(:each) do
    @period = Period.new(:name => 'Testing Period model', :ptype => 1, :lodate => '1962-02-12 00:00:00.000')
  end
  
  it "should be valid when new" do
    @period.should be_valid
  end
end
