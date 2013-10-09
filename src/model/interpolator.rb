class Interpolator
 
  def polinomio puntos
  
    calculateFirstColumn puntos
    
  end
  
  def calculateFirstColumn puntos
    array = []
    for i in 0..puntos.length-2
      puntoA = puntos[i]
      puntoB = puntos[i+1]
      array[i] = (puntoA.y - puntoB.y) / (puntoA.x - puntoB.x) 
    end
    array
  end
  
  def calculateColumn valores
    array = []
    for i in 0..valores.length-2
      array[i] = (valores[i] - valores[i+1]) / 2
    end
    array
  end
end