class Interpolator
 
  attr_accessor :columns
  
  def interpolate points
    
    first_column = calculateFirstColumn(points) #calculo la primera columna a partir de los puntos
    @columns = [first_column]   #me guardo la primera columna en el array
    column = calculateColumn first_column      #calculo la siguiente columna a partir de la primera

    while column and column.length >0                      
      @columns  << column                       #me guardo la columna en el array
      column = calculateColumn column           #calculo la siguiente columna a partir de la anterior
    end
    @columns    
  end
  
  def calculateFirstColumn points
    length = points.length
    return nil if length < 2 #aseguramos que hay mas de dos puntos
    array = []
    for i in 0..length-2
      pointA = points[i]
      pointB = points[i+1]
      array[i] = (pointA.y - pointB.y) / (pointA.x - pointB.x) 
    end
    array
  end
  
  def calculateColumn values
    length = values.length
    return nil if length < 2  #aseguramos que hay mas de dos valores
    array = []
    for i in 0..values.length-2
      array[i] = (values[i] - values[i+1]) / 2
    end
    array
  end
end

if __FILE__ == $0 
  require_relative "../model/point"
  interpolator = Interpolator.new
  puts interpolator.interpolate([[-1,2],[3,4],[40,20]].map{|p| Point.new p})
end