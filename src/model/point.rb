class Point

  include Comparable
  attr_accessor :x, :y

  def ==(otherPoint)
    self.x == otherPoint.x and self.y == otherPoint.y    
  end
  
  def <=>(otherPoint)
    comp = self.x <=> otherPoint.x
    (comp==0)? (self.y<=>otherPoint.y) : comp
  end
  
  def initialize vector
    @x = vector[0]
    @y = vector[1]
  end
  
  def y
    @y.to_f
  end
  
  def x
    @x.to_f
  end
  
  def to_s
    "(#{self.x},#{self.y})"
  end

  def self.parse string
      point = string.split(",").map {|c| Float(c)} 
      raise PointFormatException.new if point.length!=2     
      Point.new(point)
  rescue 
    raise PointFormatException.new  
  end

  def self.parse_list list
    list.map { |e| Point.parse(e)}
  end

end

class PointFormatException < Exception
  def initialize
    super "El formato de los datos debe ser x,y"
  end
end

def p x,y
  Point.new([x,y])
end