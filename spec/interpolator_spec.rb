require 'rspec'
require_relative '../src/model/interpolator.rb'

describe Interpolator do
  
  before :each do
    @interpolator = Interpolator.new
  end
  
  context "when interpolating" do
    it "should not explode" do       
      @interpolator.points = [[-1,2],[3,4],[40,20]].map{|p| Point.new p}
      @interpolator.interpolate
    end
  end
  
end
