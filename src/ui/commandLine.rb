class CommandLine
  
  def initialize interpolator = nil
  
    @interpolator = interpolator
    
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
      
      points = []
      begin
        params.each { |param| points << parse_point(param)}
        puts "No implementado. Agrega los puntos: #{points*","}"
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
    puts "No implementado. Muestra lista de puntos"
  end
  
  def clear
    puts "No implementado. Borra todo para interpolar algo nuevo"
  end
  
  def exec_command input
    
    command, *params = input.split(/\s/)
    
    case command
    
      when /\Aadd\z/i
        add params
      when /\Arm\z/i
        rm params
      when /\Ainterpolate\z/i
        interpolate 
      when /\Acalculate\z/i
        calculate params
      when /\Apoints\z/i
        points 
      when /\Aclear\z/i
        clear 
      when /\Aquit\z/i
        abort("Adios!")
      when /\Ahelp\z/i
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
