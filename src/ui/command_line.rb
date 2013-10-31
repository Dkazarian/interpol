class CommandLine
  
  #Constructor
  def initialize 
     reset
     cmd_trace
  end

  def reset
    @interpolator = Interpolator.new
    @recalculate = false
  end
  
  def exec_command input
    command, *params = input.split(/\s/)
    (params.empty?)? send("cmd_#{command}") : send("cmd_#{command}", params)
  rescue NoMethodError => e
    raise unless e.message.include?("cmd_#{command}") 
    puts "No existe el comando #{command}. Para ver los comandos, use help"
  end       

  def start

    cmd_help
    
    until @exit
      print "\n> "
      exec_command gets.chop 
    end
      
  end   


  #########################################
  #               COMMANDS                #
  #########################################
  def cmd_quit 
    @exit = true
  end

  def cmd_help  
    
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
    
  def cmd_trace  
    @interpolator.verbose =  @interpolator.verbose^true
  end  
  
  def cmd_add params
    forall_points params, :add_point
  end 
  
  def cmd_rm params
    forall_points params, :remove_point
  end 
    
  def forall_points list, method
    Point.parse_list(list).each {|p| @interpolator.send(method,p)}
    @recalculate? cmd_interpolate : cmd_points
  rescue PointFormatException => e
    puts e.message
  end

  def cmd_interpolate  
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
  
  
  def cmd_calculate params
    puts @interpolator.calculate(Float(params[0])) 
  rescue PointFormatException => e
    puts e.message
  end 
  
  
  def cmd_points 
    puts @interpolator.points.length > 0? "#{@interpolator.points*"\n"}" : "No se ingresaron puntos."
  end
  
  def cmd_clear
    reset
    puts "Se eliminaron todos los puntos."
  end
  
end


