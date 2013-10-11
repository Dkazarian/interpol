class CommandLine
  
  def initialize interpolator = nil
  
    @interpolator = interpolator
    @points = []
    
  end

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
    
  def parse_point string
      
      point = string.split(",").map {|c| Float(c)} 
      Point.new(point)unless point.length!=2     
  end
  
  def add params
    new_points = []
      begin
        params.each { |param| new_points << parse_point(param)}
        @points << new_points
        puts "Se agregaron los puntos: #{new_points*","}"
      rescue
        puts "Formato invalido"
      end
  end

  
  def rm params
    points = []
      begin
        params.each { |param| points << parse_point(param)}
        puts "No implementado. Elimina los puntos: #{points*","}"
      rescue e    
        puts "Formato invalido"
      end  
  end
  
  
  def interpolate 
    puts "No implementado. Calcula(si es necesario) y muestra polinomio interpolante"    
  end
  
  
  def calculate params
    puts "No implementado. Evalua el polinomio en #{params}"  
  end
  
  
  def points
    if @points.length > 0
      puts "#{@points*",\n"}"
    else
      puts "No se ingresaron puntos."
    end
  end
  
  def clear
    puts "No implementado. Borra todo para interpolar algo nuevo"
  end
  
  def exec_command input
    
    command, *params = input.split(/\s/)
    
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
        abort("Adios!")
      when /help/
        help
      else
        puts "No existe el comando. Para ver los comandos, use help"
    end   
  
  end
    
  def start
  
    help
    
    loop do 
      print "\n> "
      exec_command gets.chop
    end
      
  end   


end

#Si este es el archivo que se ejecuto (si le di run a este .rb y no a otro que lo incluye)
if __FILE__ == $0 
  require_relative "../model/point"
  CommandLine.new.start
end
