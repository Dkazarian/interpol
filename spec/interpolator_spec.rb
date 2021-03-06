require 'rspec'
require_relative '../src/model/interpolator.rb'

describe Interpolator do
  
  before :each do
    @interpolator = Interpolator.new    
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
      @interpolator.interpolate!    
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
        @interpolator.progressive_polynomial.to_s.should eq "1 + (x - 1) + 3(x - 1)(x - 3) + (x - 1)(x - 3)(x - 4)"
      end          
      
      it "should obtain the correct coeficients" do      
        @interpolator.progressive_product(0).should eq ""
        @interpolator.progressive_product(1).should eq "(x - 1.0)"      
        @interpolator.progressive_product(2).should eq "(x - 1.0)*(x - 3.0)"      
        @interpolator.progressive_product(3).should eq "(x - 1.0)*(x - 3.0)*(x - 4.0)"   
      end
    end
    
    context "regressive polynomial" do
      it "should obtain the same polynomial" do
        @interpolator.regressive_polynomial.to_s.should eq "151 + 57(x - 7) + 11(x - 7)(x - 5) + (x - 7)(x - 5)(x - 4)"
      end
      
      it "should obtain the correct regressive coeficients" do
        @interpolator.regressive_product(0).should eq ""
        @interpolator.regressive_product(1).should eq "(x - 7.0)"      
        @interpolator.regressive_product(2).should eq "(x - 7.0)*(x - 5.0)"      
        @interpolator.regressive_product(3).should eq "(x - 7.0)*(x - 5.0)*(x - 4.0)"
      end
      
    end 
    

  end


  describe :interpolate! do

    it "should not explode when doing this thing that mades it explode(?)" do
      [p(1,4), p(0,5), p(123,4)].each {|p| @interpolator.add_point p}
      @interpolator.interpolate!
      @interpolator.add_point p(0,4)
      @interpolator.interpolate!
    end

    it "should not explode when interpolating after removing points" do
      [p(1,1), p(0,0), p(2,2)].each {|p| @interpolator.add_point p}
      @interpolator.interpolate!
      [p(0,0), p(2,2), p(1,1)].each do |p| 
        @interpolator.remove_point p
        @interpolator.interpolate!
      end
    end

    context "when removing an extra point" do
      it "should not recalculate the polynomial" do
        [p(1,1), p(0,0), p(2,2)].each {|p| @interpolator.add_point p}

        @interpolator.interpolate!

        @interpolator.remove_point p(2,2)
        @interpolator.refresh.should==false 

      end
    end

    context "when adding a point included in the polynomial" do
      it "should not recalculate the polynomial" do
        [p(1,1), p(0,0), p(2,2)].each {|p| @interpolator.add_point p}

        @interpolator.interpolate!
        @interpolator.add_point p(4,4)      

        @interpolator.refresh.should == false    
      end
    end

    context "when adding a point not included in the polynomial" do
      it "should recalculate the polynomial" do
        [p(1,1), p(0,0), p(2,2)].each {|p| @interpolator.add_point p}
        @interpolator.interpolate!       

        @interpolator.add_point p(10,4)
        @interpolator.refresh.should==true 
      end
    end
  end

  describe :minimal_grade do
      before :each do
      @points = [
                  p(1,1), 
                  p(2,2)
              ]
      @interpolator.points = @points
      @interpolator.interpolate!
    end
    
    it "should return true after interpolating" do
      @interpolator.minimal_grade.should == true
    end

    it "should return true after removing an extra point" do
      @interpolator.add_point p(3,3)
      @interpolator.interpolate!
      @interpolator.remove_point p(2,2)
      @interpolator.minimal_grade.should == true
    end

    #Deberia dar false porque existe polinomio de grado menor (y = 1)
    it "should return false after removing a non-extra point" do
      @interpolator.remove_point p(1,1)      
      @interpolator.minimal_grade.should == false
    end


    it "should return true after adding a point" do
      @interpolator.add_point p(11,1)
      @interpolator.minimal_grade.should == true
    end
  end
  
end
