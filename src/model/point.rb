class Point

  include Comparable

  def initialize x,y
    @x = x
    @y = y
  end


  #Sobreescribe el == para que sepa comparar Point
  def ==(otherPoint)
    self.x == otherPoint.x and self.y == otherPoint.y    
  end
  
  #Sobreescribe la funcion de ordenamiento
  #usada por el metodo order de las colecciones.
  def <=>(otherPoint)
    comp = self.x <=> otherPoint.x
    (comp==0)? (self.y<=>otherPoint.y) : comp
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


  ##########################################
  #             CLASS METHODS              #
  ##########################################


  #Separa un string "x,y" en dos floats y retorna un Point
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

#Funcion cortita para poder poner p(x,y) en vez 
#tener que hacer Point.new(x,y)
def p x,y
  Point.new(x,y)
end