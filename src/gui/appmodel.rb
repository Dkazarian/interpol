
require_relative "../model/interpolator.rb"

class Model
  def initialize
    @interpolator = Interpolator.new
  end
  
  def add x, y
    point = Point.new Float(x), Float(y)
    interpolator.add_point point
  end
  
  def rm point
    interpolator.remove_point point
  end
  
  def points
    interpolator.points.sort
  end
  
  def clear
    @interpolator = Interpolator.new
  end
  
  def calculate x
    interpolator.calculate x
  end
  
  def interpolate
    interpolator.interpolate
  end
  
  def interpolator
    @interpolator
  end
end