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
      
  context "when using the example of page 85" do
  
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
    
    it "should obtain the correct amount of deltas" do
    
      @deltas = @interpolator.deltas
      @deltas.length.should eq @points.length 
      for i in 0..@deltas.length-1
        @deltas[i].length.should == @points.length - i 
      end
    end

    it "should obtain the same deltas" do
      
      @interpolator.deltas.should == [ 
                                                   [1,3,13,37,151],
                                                    [1,10,24,57],
                                                      [3,7,11],
                                                       [1,1],
                                                        [0]
                                                  ]        
    end
    
    context "progressive polynomial" do
      it "should obtain the same polynomial" do
        @interpolator.progressive_polynomial.should eq "1 + 1(x - 1) + 3(x - 1)(x - 3) + 1(x - 1)(x - 3)(x - 4)"
      end          
      
      it "should obtain the correct coeficients" do      
        @interpolator.progressive_product(0).should eq ""
        @interpolator.progressive_product(1).should eq "(x - 1)"      
        @interpolator.progressive_product(2).should eq "(x - 1)(x - 3)"      
        @interpolator.progressive_product(3).should eq "(x - 1)(x - 3)(x - 4)"   
      end
    end
    
    context "regressive polynomial" do
      it "should obtain the same polynomial" do
        @interpolator.regressive_polynomial.should eq "151 + 57(x - 7) + 11(x - 7)(x - 5) + 1(x - 7)(x - 5)(x - 4)"
      end
      
      it "should obtain the correct regressive coeficients" do
        @interpolator.regressive_product(0).should eq ""
        @interpolator.regressive_product(1).should eq "(x - 7)"      
        @interpolator.regressive_product(2).should eq "(x - 7)(x - 5)"      
        @interpolator.regressive_product(3).should eq "(x - 7)(x - 5)(x - 4)"
      end
      
    end 
    

  end
    
  
  
end
