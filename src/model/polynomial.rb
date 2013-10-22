class Polynomial

  def initialize formula  
    @formula = formula
  end
  
  def evaluate(x)
    eval(replace_x_for_value x)
  end
  
  def includes? point
    evaluate(point.x) == point.y
  end
  
  def replace_x_for_value value
    @formula.gsub "x", value.to_s
  end
  
  def to_s
    @formula.gsub(/.0\D/){|m| m.delete ".0"}.delete("*").gsub(/\D1\(/){|m| m.delete "1"}
  end
end