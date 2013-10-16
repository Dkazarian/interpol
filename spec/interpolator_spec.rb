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
  
  context "progressive polynomial" do
    
    it "should obtain the same deltas than the example of page 85" do
      @interpolator.points = [p(1,1), p(3,3), p(4,13), p(5,37), p(7,151)]
      @interpolator.progressive_deltas.should == [ 
                                                    [1,10,24,57],
                                                      [3,7,11],
                                                       [1,1],
                                                        [0]
                                                  ]
      
    end
  end
  
end
