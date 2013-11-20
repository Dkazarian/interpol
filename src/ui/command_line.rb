class CommandLine
  
  #Constructor
  def initialize interpolator
    @interpolator = interpolator
    @interpolator.add_listener self, :polynomial_changed
    @interpolator.add_listener self, :info, :print_interpolator_info
    @show_info = true
  end


  #Muestra la lista de comandos y despues lee y ejecuta comandos hasta que el 
  #usuario ponga quit 
  def start

    cmd_help
    
    until @exit
      print "\n\n> "
      exec_command gets 
    end
      
  end   



  ####################################################################
  #<* ><|<* ><|<* ><|<* ><|<* ><|COMANDOS|><|<* ><|<* ><|<* ><|<* ><|#                  
  ####################################################################


  def cmd_quit params = nil
    @exit = true
  end

  def cmd_exit params = nil
    cmd_quit params
  end

  def describe_command cmd, desc
    puts "#{cmd} \t#{desc}"
  end
  
  def cmd_help params = nil
    
    puts ("="*40)
    puts "Comandos disponibles"
    puts ("="*40)
    describe_command "add x1,y1 x2,y2 xn,yn", "Agrega punto/s" 
    describe_command "rm x1,y1 x2,y2 xn,yn", "Remueve punto/s"
    describe_command "interpolate", "Muestra o calcula el polinomio interpolador. Atajo: #{"int"}."
    describe_command "evaluate x",  "Evalua el polinomio en x. Atajo: #{"eval"}."
    describe_command "points", "Muestra la lista actual de puntos"
    describe_command "clear", "Limpia la lista de puntos"    
    describe_command "deltas", "Muestra la tabla de deltas"
    describe_command "help", "Muestra comandos disponibles"
    describe_command "quit", "Salir"
    puts ("="*40)
    puts "Escriba #{"demo"} para ver un ejemplo"
    puts ""
    
  end
  
  #Activa o desactiva los impresion de los mensajes del interpolador
  def cmd_info params = nil
    @show_info =  @show_info^true
  end  
  
  #Agrega todos los puntos en params a la lista del interpolador
  def cmd_add params
    forall_points params, :add_point
    
  end 
  
  #Remueve todos los puntos de params  
  def cmd_rm params
    forall_points params, :remove_point
  end 
  
  def cmd_remove params
    cmd_rm params
  end

  #Le dice al interpolador que interpole
  def cmd_interpolate params = nil
    @interpolator.interpolate!
  end
  
  def cmd_int params
    cmd_interpolate params
  end

  #Le pide al interpolador que evalue un punto en el polinomio
  def cmd_evaluate params
    x = Float(params[0]) rescue nil
    if x
      puts @interpolator.evaluate(x).to_s 
    else
      puts "No se puede evaluar '#{params[0]}'"
    end
  end 

  def cmd_eval params
    cmd_evaluate params
  end
  
  #Imprime la lista de puntos
  def cmd_points params = nil
    puts @interpolator.points.length > 0? "#{@interpolator.points*"\n"}" : "No se ingresaron puntos."
  end
  
  #Resetea
  def cmd_clear params = nil
    @interpolator.clear
    puts "Se eliminaron todos los puntos."
  end

  def cmd_clr params = nil
    cmd_clear params
  end
 
  def cmd_deltas params = nil
    deltas = @interpolator.deltas
    length = deltas.length - 1
    for ii in 0..length
      for i in 0..length-ii
        print "#{deltas[i][ii]}\t"
      end
      puts ""
    end
  end
  
  def cmd_demo params = nil
    commands = [
      "add 10,10 30,30 40,130 80,370 170,151",
      "add 2,3 4,pato",
      "basura",
      "interpolate",
      "deltas",
      "evaluate 6",
      "evaluate 7",
      "evaluate tortuga",
      "evaluate -4.2",
      "add 0,0",
      "rm 4,13",
      "rm 7,151", 
      "clear"
      ]
    commands.each do |cmd|
      puts "\n> #{cmd}\n"
      sleep 1
      exec_command cmd
      puts ""
      sleep 2
    end
    puts "\n\t\t#{"**"}Fin de la demostracion#{"**"}\n\n"
  end

  def cmd_about params = nil
    puts "Interpolator\n\nDaniela Belen Kazarian\nFranco Tomas Hecht\nPablo Santiago Fernandez\n\n2013"
  end
  



  ####################################################################
  #<* ><|<* ><|<* ><|<* ><|<* ><|PRIVADOS|><|<* ><|<* ><|<* ><|<* ><|#                  
  ####################################################################
  private


  #handlers 
  def print_interpolator_info params
    if @show_info
      puts ""
      puts params
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
    if input
      command, *params = input.split(/\s/) 
      if self.respond_to? "cmd_#{command}"
        send("cmd_#{command}", params)
      else
        puts "No existe el comando '#{command}'. Para ver los comandos, use help"
      end
    end
  end
  


  def polynomial_changed params
    if @interpolator.polynomial
      puts ""
      puts ("*"*20)
      puts "Progresivo: "
      puts "p(x) = " + @interpolator.progressive_polynomial.to_s
      puts "Regresivo: "
      puts "p(x) = " + @interpolator.regressive_polynomial.to_s
      puts ("*"*20)
    end
  end

  #Convierte los strings "x,y" de la lista a formato punto 
  #y ejecuta la funcion del planificador que se le paso en method.  
  #Si ya habia puntos intenta recalcular. Sino imprime la lista 
  #resultante.  
  def forall_points list, method
    Point.parse_list(list).each {|p| @interpolator.send(method,p)}
    @interpolator.refresh
  rescue PointFormatException => e
    puts e.message
  end

end
