class Interpolator
 
  @columns #lista de listas
  
  def polinomio points
    
    first_column = calculateFirstColumn points  #calculo la primera columna a partir de los puntos
    @columns[0] = first_column                  #me guardo la primera columna
    column = calculateColumn first_column       #calculo la siguiente columna a partir de la primera
    i = 1
    while column                                #while que corta cuando la columna devuelve null?
      @columns[i] = column                      #me guardo la columna en el array
      column = calculateColumn column           #calculo la siguiente columna a partir de la anterior
      i++
    end
    
  end
  
  def calculateFirstColumn points
    length = points.length
    if length < 2 return nil #aseguramos que hay mas de dos puntos
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
    if length < 2 return nil #aseguramos que hay mas de dos valores
    array = []
    for i in 0..values.length-2
      array[i] = (values[i] - values[i+1]) / 2
    end
    array
  end
end