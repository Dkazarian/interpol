require_relative "model"

class Interpolator
  
  attr_accessor :points
  def initialize
    @points = []
  end
  
 
  def remove_point point    
    @points.delete point
  end
  
  def add_point point
    @points<<point
  end
  
  def deltas
    points.sort
    deltas = [@points.map {|p| p.y}]
    n = @points.length
    for i in 1..n-1
      deltas[i]=[]
      for o in 0..n-i-1
        deltas[i][o] = (deltas[i-1][o+1] - deltas[i-1][o]) / (@points[o+i].x - @points[o].x)   
      end
    end
    deltas
    
  end
  
  
  def progressive_product k
    str = ""
    for i in 0..k-1
      str+= "(x-#{points[i].x})"
    end
    str
  end
  
  def progressive_polynomial    
    "1 + 1.(x-1) + 3.(x-1)(x-3) + 1.(x-1)(x-3)(x-4)"
  end
  

  
  def interpolate 
    #calcula polinomios si es necesario. Retorna true o false segun si hubo q calcular.
  end
  
  
  
end

