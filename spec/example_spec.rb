require 'rspec'

describe :Example do  
  
  it "should pass" do
    3.should == 3
  end
  
  it "should fail" do    
    2.should == 1
  end
  
end

