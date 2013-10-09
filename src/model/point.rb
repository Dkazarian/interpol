class Point

  include Comparable
  attr_accessor :x, :y

  def <=>(otherPoint)
    comp = self.x <=> otherPoint.x
    (comp==0)? (self.y<=>otherPoint.y) : comp
  end
  
  def initialize vector
    @x = vector[0]
    @y = vector[1]
  end
    
  
  def to_s
    "(#{self.x},#{self.y})"
  end
end
