class ConsoleUi

  def initialize interpolator
  
    @interpolator = interpolator
    
  end
  
  def get_input
    str = gets.chomp
    
    throw :fin if str == "fin"
  
    str
  end

  def get_punto
      
      punto = get_input.split(",").map {|c| Float(c)} rescue nil
    
      punto unless punto.length!=2 rescue nil 
    
  end
  
  
  def obtener_puntos
    puntos = []
    catch :fin do
      while true do
  
        puts "\nIngrese punto"
        punto = get_punto 
        if punto 
          puntos<< Point.new(punto) #cambiar por algo asi como @interpolator.addPoint punto
        else 
          puts 'Formato invalido' 
        end
      end 
    end
    
    puntos.sort 
  
  end
  
  def start 
    puntos = obtener_puntos 

    puts "Puntos: #{puntos*","}"
    puts "DeltasF1: #{@interpolator.polinomio(puntos)*","}"
  end
end

