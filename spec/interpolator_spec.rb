require 'rspec'
require_relative '../src/model/interpolator.rb'

describe Interpolator do
  
  before :each do
    @interpolator = Interpolator.new
  end
  
  context "when interpolating" do
    it "should not explode :P" do       
      @interpolator.points = [p(-1,2),p(3,4),p(40,20)]
      @interpolator.interpolate
    end
    
  end
  
  context "progressive deltas" do
    before :each do
      @points = [ 
                  p(1,1), 
                  p(3,3), 
                  p(4,13), 
                  p(5,37), 
                  p(7,151)
                ]
      @interpolator.points = @points
      @interpolator.interpolate
    end
    
    it "should have the correct amount of deltas" do
      
      @deltas = @interpolator.progressive_deltas
      @deltas.length.should == @points.length - 1
      for i in 0..@deltas.length-1
        @deltas[i].length.should == @points.length - i - 1
      end
    end
    
    it "should obtain the same deltas of the example of page 85" do
      
      @interpolator.progressive_deltas.should == [ 
                                                    [1,10,24,57],
                                                      [3,7,11],
                                                       [1,1],
                                                        [0]
                                                  ]
      
    end
    
    it "should obtain the same polynomial of the example of page 85" do
      @interpolator.progressive_polynomial.should == "1 + 1.(x-1) + 3.(x-1)(x-3) + 1.(x-1)(x-3)(x-4)"
    end
    
    
  end
  
end