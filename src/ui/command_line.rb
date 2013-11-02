class CommandLine
  
  #Constructor
  def initialize 
     reset
     cmd_trace
  end

  #Limpia todo, al usar un Interpolator nuevo se borran
  #los polinomios y los puntos  (si habian)
  def reset
    @interpolator = Interpolator.new
    @recalculate = false
  end 


  #Muestra la lista de comandos y despues lee y ejecuta comandos hasta que el 
  #usuario ponga quit 
  def start

    cmd_help
    
    until @exit
      print "\n> "
      exec_command gets.chop 
    end
      
  end   


  #Ejecuta la funcion cmd_"nombre_del_comando_ingresado" si existe
  # En command queda la primer palabra ingresada
  # y en params un vector con el resto de las cosas
  # Ejemplo:
  #     El usuario ingresa add x1,y1 x2,y2 x3,y3
  #     Queda:
  #     command: "add"
  #     params: ["x1,y1", "x2,y2", "x3,y3"]
  def exec_command input

    command, *params = input.split(/\s/) 
    (params.empty?)? send("cmd_#{command}") : send("cmd_#{command}", params)
  rescue NoMethodError => e
    raise unless e.message.include?("cmd_#{command}") 
    puts "No existe el comando #{command}. Para ver los comandos, use help"
  end   




  #########################################
  #               COMMANDOS               #
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
    puts "evaluate x\tEvalua el polinomio en x"
    puts "points\tMuestra la lista actual de puntos"
    puts "clear\tLimpia la lista de puntos"    
    puts "help\tMuestra comandos disponibles"
    puts "quit\tSalir"
    puts "="*40
    puts ""
    
  end
  
  #Activa o desactiva los mensajes del interpolador
  def cmd_trace  
    @interpolator.verbose =  @interpolator.verbose^true
  end  
  
  #Agrega todos los puntos en params a la lista del interpolador
  def cmd_add params
    forall_points params, :add_point
  end 
  
  #Remueve todos los puntos de params  
  def cmd_rm params
    forall_points params, :remove_point
  end 
  
  #Convierte los strings "x,y" de la lista a formato punto 
  #y ejecuta la funcion del planificador que se le paso en method.  
  #Si ya habia puntos intenta recalcular. Sino imprime la lista 
  #resultante.
  def forall_points list, method
    Point.parse_list(list).each {|p| @interpolator.send(method,p)}
    @recalculate? cmd_interpolate : cmd_points
  rescue PointFormatException => e
    puts e.message
  end

  #Le dice al interpolador que interpole y si se recalcularon los polinomios
  #los muestra
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
  
  #Le pide al interpolador que evalue un punto en el polinomio
  def cmd_evaluate params
    puts @interpolator.evaluate(Float(params[0])) 
  rescue PointFormatException => e
    puts e.message
  end 
  
  #Imprime la lista de puntos
  def cmd_points 
    puts @interpolator.points.length > 0? "#{@interpolator.points*"\n"}" : "No se ingresaron puntos."
  end
  
  #Resetea
  def cmd_clear
    reset
    puts "Se eliminaron todos los puntos."
  end
  
end