require_relative "model"

class Interpolator
  attr_accessor :points
  @points = []
  
  def points points
    @points = points.sort
  end
  
  def remove_point point    
    @points.delete point
  end
  
  def add_point point
    @points<<point
  end
  
  def deltas
    
    deltas = [] << @points.map {|p| p.y}
    n = @points.length
    for i in 1..n-1
      deltas[i]=[]
      for o in 0..n-i-1
        deltas[i][o] = (deltas[i-1][o+1] - deltas[i-1][o]) / (@points[o+1].x - @points[o].x)   
      end
    end
    deltas
    
  end
  
  def progressive_polynomial    
    "1 + 1.(x-1) + 3.(x-1)(x-3) + 1.(x-1)(x-3)(x-4)"
  end
  

  
  def interpolate 
    first_column = calculateFirstColumn @points
    return if first_column == nil
    columns = [first_column]
    column = calculateColumn first_column

    while column
      columns << column
      column = calculateColumn column
    end
    columns
  end
  
  def calculateFirstColumn points
    length = points.length
    return nil if length < 2 #aseguramos que hay mas de dos puntos
    array = []
    for i in 0..length-2
#      binding.pry
      pointA = points[i]
      pointB = points[i+1]
      array[i] = interpolatePoints pointA, pointB
    end
    array
  end
  
  def interpolatePoints pointA, pointB
    (pointA.y - pointB.y) / (pointA.x - pointB.x)
  end
  
  def calculateColumn values
    length = values.length
    return nil if length < 2  #aseguramos que hay mas de dos valores
    array = []
    for i in 0..values.length-2
      valueA = values[i]
      valueB = values[i+1]
      array[i] = interpolateValues valueA, valueB
    end
    array
  end
  
  def interpolateValues valueA, valueB
    (valueA - valueB) / 2
  end
  
end

