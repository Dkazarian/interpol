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
  
  def regressive_product k
    str = ""
    for i in 0..k-1
      str+= "(x-#{points[points.length-1-i].x})"
    end
    str
  end
  
  def progressive_deltas
    deltas.map{|column| column.first}
  end
  
  def regressive_deltas
    deltas.map{|column| column.last}
  end
  
  def polynomial_string deltas, product
    str = ""
    size = deltas.length
    for i in 0..size-1
      delta = deltas[i]
      if delta != 0
        str += "#{delta}#{send product, i}"
        str += " + " if i < size-2
      end
    end
    str
  end
  
  def progressive_polynomial
    polynomial_string progressive_deltas, :progressive_product
  end
  
  def regressive_polynomial
    polynomial_string regressive_deltas, :regressive_product
  end
  

  
  def interpolate 
    #calcula polinomios si es necesario. Retorna true o false segun si hubo q calcular.
  end
  
  
  
end

