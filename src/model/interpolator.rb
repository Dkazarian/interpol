class Interpolator
  
  attr_accessor :points, :verbose
  
  def initialize
    @points = []
    @verbose = false
  end
  
  def trace msj
    puts msj if @verbose    
  end
    
  def remove_point point    
    @points.delete point
    @point_removed = true
  end
  
  def add_point point    
    @points = @points.delete_if {|p| p.x == point.x}      
    @points<<point    
  end
  
  #Calcula la tabla de deltas y la almacena en una lista de listas
  #Ejemplo:
  #                  [
  #                    [1,3,13,37,151],
  #                     [1,10,24,57],
  #                       [3,7,11],
  #                        [1,1],
  #                         [0]
  #                                  ]      
  def calculate_deltas
    trace("Ordenando puntos.")
    points.sort!
    
    trace("Construyendo tabla de diferencias divididas.")
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
  
  def deltas
    @deltas
  end
  
  #Arma los (x-a)(x-b)(x-c) para el termino k
  def progressive_product k
    str = ""
    for i in 0..k-1
      r = points[i].x
      str+= (r==0)? "x" : "(x - #{r})" 
    end
    str
  end
  
  #Arma los (x-c)(x-b)(x-a) para el termino k
  def regressive_product k
    str = ""
    for i in 0..k-1
      r = points[points.length-1-i].x
      str+= (r==0)? "x" : "(x - #{r})"
    end
    str
  end
  
  def progressive_deltas
    @deltas.map{|column| column.first}
  end
  
  def regressive_deltas
    @deltas.map{|column| column.last}
  end
  
  #Arma el string del polinomio
  def polynomial_string deltas, product
    terms = []

    for i in 0..deltas.length-1      
      terms << "#{deltas[i]}#{send product, i}" unless deltas[i] == 0      
    end

    (terms*" + ").gsub("- -","+ ").gsub("+ -","- ")    
  end
  
  def progressive_polynomial
    @progressive_polynomial
  end
  
  def regressive_polynomial
    @regressive_polynomial
  end
    
  #Calcula los polinomios si es necesario
  def interpolate 
    
    if must_recalculate 
      @deltas = calculate_deltas 
      
      trace("Construyendo polinomio progresivo.")
      @progressive_polynomial = Polynomial.new polynomial_string(progressive_deltas, :progressive_product)
      
      
      trace("Construyendo polinomio regresivo.")
      @regressive_polynomial = Polynomial.new polynomial_string(regressive_deltas, :regressive_product)      
    end   
 
  end
  
  #Los polinomios deben calcularse si se quitaron puntos
  #si no estan calculados o si se agregaron puntos fuera de los actuales
  def must_recalculate    

    if @point_removed or not @progressive_polynomial
      @point_removed = false
      return true
    end    

    points.detect {|point| not @progressive_polynomial.includes? point}    

  end 
  
  #Evalua el punto en uno de los polinomios. Interpola si no estaba calculado.
  def evaluate x    
    interpolate unless @progressive_polynomial
    @progressive_polynomial.evaluate x     
  end
  
end

