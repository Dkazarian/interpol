class CommandLine
  
  def initialize 
     reset
  end

  def reset
    @interpolator = Interpolator.new
    trace
    @recalculate = false
  end
  
  
  def exec_command input
    
    command, *params = input.split(/\s/)
    exit = false
    #begin
      
    case command
      when /add/
        add params
      when /rm/, /remove/
        rm params
      when /interpolate/
        interpolate 
      when /calculate/
        calculate params
      when /points/
        points 
      when /clr/, /clear/
        clear 
      when /quit/, /exit/
        exit = true
      when /trace/
        trace
      when /help/
        help
      else
        puts "No existe el comando. Para ver los comandos, use help"
    end   
  
    abort("Adios!") if exit
  end
    
  def start
      
    help
    
    loop do 
      print "\n> "
      begin
        exec_command gets.chop 
      rescue ArgumentError,TypeError=>e
        puts "Formato invalido: "+ e.to_s
      end
    end
      
  end   


  #########################################
  #               COMMANDS                #
  #########################################
  
  def help
    
    puts "="*40
    puts "Comandos disponibles"
    puts "="*40
    puts "add x1,y1 x2,y2 xn,yn\tAgrega punto/s" 
    puts "rm x1,y1 x2,y2 xn,yn\tRemueve punto/s"
    puts "interpolate\tMuestra o calcula el polinomio interpolador"
    puts "calculate x\tEvalua el polinomio en x"
    puts "points\tMuestra la lista actual de puntos"
    puts "clear\tLimpia la lista de puntos"    
    puts "help\tMuestra comandos disponibles"
    puts "quit\tSalir"
    puts "="*40
    puts ""
    
  end
    
  def trace
    @interpolator.verbose =  @interpolator.verbose^true
  end
  def parse_point string
      point = string.split(",").map {|c| Float(c)} 
      raise ArgumentError.new("El formato de los datos debe ser x,y") if point.length!=2     
      Point.new(point)
  end
  
  def add params
    new_points = []
    params.each { |param| new_points << parse_point(param)}
    new_points.each {|p| @interpolator.add_point p}
    points
    interpolate if @recalculate
  end

  
  def rm params
    rm_points = []
    params.each { |param| rm_points << parse_point(param)}
    rm_points.each{|p| @interpolator.remove_point p}
    points
    interpolate if @recalculate
  end
    
  def interpolate 
     puts ""
     if @interpolator.interpolate
       puts "*"*20
       puts "Progresivo: "
       puts "p(x) = " + @interpolator.progressive_polynomial.to_s
       puts "Regresivo: "
       puts "p(x) = " + @interpolator.regressive_polynomial.to_s
       puts "*"*20
     else
       puts "Los polinomios no debieron recalcularse" 
     end
     @recalculate = true
  end
  
  
  def calculate params
    puts @interpolator.calculate(Float(params[0])) 
  end
  
  
  def points
    puts @interpolator.points.length > 0? "#{@interpolator.points*"\n"}" : "No se ingresaron puntos."
  end
  
  def clear
    reset
    puts "Se eliminaron todos los puntos."
  end
  
end

