require 'rspec'
require_relative '../src/model/point.rb'

describe Point do
  
  it "should compare correctly" do    
    p(4,-5.2).should==p(4,-5.2)
  end
  
  it "should sort by x,y" do
    [p(2,-4), p(1,-4.5), p(100,-4), p(1,2)].sort.should == [p(1,-4.5), p(1,2), p(2,-4), p(100,-4)]
  end
  
  it "should parse a point" do
  	Point.parse("2.4,5").should == p(2.4,5)
  end

  it "should parse a point list" do
  	Point.parse_list(["24,3","13,5","22.0,10", "14,7.8"]).should == [p(24,3), p(13,5), p(22.0,10), p(14,7.8)]
  end
end


