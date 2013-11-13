require_relative "events"
class Interpolator
  include Events
  attr_accessor :points
  
  def initialize 
    clear
  end
  
  def clear
    @deltas = nil
    @points = []
    @progressive_polynomial = nil
    @regressive_polynomial = nil
    notify :polynomial_changed
  end
  
  def trace msj
    notify :info, msj 
  end
    
  def remove_point point    
    @points.delete(point) 
    trace "Eliminado punto: #{point}" 
  end
  
  def add_point point    
    @points = @points.delete_if {|p| p.x == point.x}      
    @points<<point   
    trace "Agregado punto: #{point}"     
  end

  def refresh
    if polynomial and (!minimal_grade or @points.any?{|point| not polynomial.includes? point})
      interpolate!
      true
    else 
      false
    end
  end

  #Calcula los polinomios
  def interpolate! 
    
    calculate_deltas

    trace("Construyendo polinomio progresivo.")
    @progressive_polynomial = Polynomial.new polynomial_string(progressive_deltas, :progressive_product)
      
      
    trace("Construyendo polinomio regresivo.")
    @regressive_polynomial = Polynomial.new polynomial_string(regressive_deltas, :regressive_product)      
     
    notify :polynomial_changed
  end

  def deltas
    calculate_deltas unless @deltas
    @deltas
  end
  
  #Evalua el punto en uno de los polinomios. Interpola si no estaba calculado.
  def evaluate x    
    interpolate! unless polynomial
    polynomial.evaluate x     
  end


  ####################################################################
  #<* ><|<* ><|<* ><|<* ><|<* ><|<* ><|<* ><|<* ><|<* ><|<* ><|<* ><|#                    
  ####################################################################


  
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
    @deltas = deltas
    deltas
  end


  def progressive_deltas
    deltas.map{|column| column.first}
  end
  
  def regressive_deltas
    deltas.map{|column| column.last}
  end

  def progressive_polynomial
    @progressive_polynomial
  end
  
  def regressive_polynomial
    @regressive_polynomial
  end


  def polynomial
    @progressive_polynomial
  end

  def minimal_grade
    grade < points.length
  end

  def grade
    grade = deltas.length-1
    while (deltas[grade].all? { |e| e==0 } and grade > 0) 
      grade-=1
    end
    grade    
  end



  ####################################################################
  #<* ><|<* ><|<* ><|<* ><|<* ><|<* ><|<* ><|<* ><|<* ><|<* ><|<* ><|#                    
  ####################################################################

  #Arma los (x-a)(x-b)(x-c) para el termino k
  def progressive_product k
    str = ""
    for i in 0..k-1
      r = points[i].x
      str+= (r==0)? "x" : "(x - #{r})"
      str+= "*" if i != k-1
    end
    str
  end
  
  #Arma los (x-c)(x-b)(x-a) para el termino k
  def regressive_product k
    str = ""
    for i in 0..k-1
      r = points[points.length-1-i].x
      str+= (r==0)? "x" : "(x - #{r})"
      str+= "*" if i != k-1
    end
    str
  end

  
  #Arma el string del polinomio
  def polynomial_string deltas, product
    terms = []
    for i in 0..deltas.length-1
      if deltas[i] != 0
        product_string = send product, i
        if product_string!=""
          terms << "#{deltas[i]}*#{product_string}" 
        else
          terms << deltas[i].to_s
        end
      end
    end
    string = (terms*" + ").gsub("* + ","").gsub("- -","+ ").gsub("+ -","- ")   
   
    (string == "")? "0" : string
  end
  

  
end

