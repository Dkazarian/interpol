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
  end
  
  def add_point point    
    @points = @points.delete_if {|p| p.x == point.x}      
    @points<<point    
  end
  
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
  
  
  def progressive_product k
    str = ""
    for i in 0..k-1
      str+= (points[i].x==0)?"x":"(x - #{points[i].x})"
    end
    str
  end
  
  def regressive_product k
    str = ""
    for i in 0..k-1
      str+= "(x - #{points[points.length-1-i].x})"
    end
    str
  end
  
  def progressive_deltas
    @deltas.map{|column| column.first}
  end
  
  def regressive_deltas
    @deltas.map{|column| column.last}
  end
  
  def polynomial_string deltas, product
    terms = []
    for i in 0..deltas.length-1
      if deltas[i] != 0
        terms << "#{deltas[i]}#{send product, i}" 
      end
    end
    (terms*" + ").gsub("- -","+ ").gsub("+ -","- ").gsub("(","*(")    
  end
  
  def progressive_polynomial
    @progressive_polynomial
  end
  
  def regressive_polynomial
    @regressive_polynomial
  end
    
  def interpolate 
    
    if must_recalculate 
      @deltas = calculate_deltas 
      
      trace("Construyendo polinomio progresivo.")
      @progressive_polynomial = Polynomial.new polynomial_string(progressive_deltas, :progressive_product)
      
      
      trace("Construyendo polinomio regresivo.")
      @regressive_polynomial = Polynomial.new polynomial_string(regressive_deltas, :regressive_product)
      
    end   
 
  end
  
  
  def must_recalculate
    if @progressive_polynomial and @regressive_polynomial
       points.detect {|point| not @progressive_polynomial.includes? point}
    else
      true
    end
  end 
  
  def calculate x    
    polynomial =  @progressive_polynomial || @regressive_polynomial
    if @points and not @points.empty?
      unless polynomial
        interpolate
        polynomial =  @progressive_polynomial || @regressive_polynomial   
      end
      polynomial.evaluate x 
    else
      raise "No se han ingresado suficientes puntos." #cambiar por exception
    end
  end
  
end

