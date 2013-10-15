class Interpolator
  
  
  def interpolate points
    first_column = calculateFirstColumn points
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

if __FILE__ == $0 
  require_relative "../model/point"
  interpolator = Interpolator.new
  puts interpolator.interpolate([[-1,2],[3,4],[40,20]].map{|p| Point.new p})
end