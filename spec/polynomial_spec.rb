require 'rspec'
require_relative '../src/model/polynomial.rb'

describe Polynomial do
  it "should format the formula correctly" do
  
  end
  describe :replace_x_for_value do
    it "should return 2+(3-1)+3*3" do
      Polynomial.new("2+(x-1)+3*x").replace_x_for_value(3).should eq "2+(3-1)+3*3"
    end
  end 
  
  describe :evaluate do
    it "should return -8" do
      Polynomial.new("2+3*x+(x-3)+5*(x-1)*(x-5)+1").evaluate(3).should ==-8
    end
  end

end