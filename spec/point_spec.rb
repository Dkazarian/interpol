require 'rspec'
require_relative '../src/model/point.rb'

describe Point do
  
  it "should compare correctly" do    
    p(4,-5.2).should==p(4,-5.2)
  end
  
  it "should sort by x,y" do
    [p(2,-4), p(1,-4.5), p(100,-4), p(1,2)].sort.should == [p(1,-4.5), p(1,2), p(2,-4), p(100,-4)]
  end
end

def p x,y
  Point.new([x,y])
end
