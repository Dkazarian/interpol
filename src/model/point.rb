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
end

def p x,y
  Point.new([x,y])
end