class Polynomial

  def initialize formula  
    @formula = formula
  end
  
  def evaluate(x)
    eval(replace_x_for_value x)
  end
  
  def replace_x_for_value value
    @formula.gsub "x", value.to_s
  end
  
  def to_s
    @formula    
  end
end