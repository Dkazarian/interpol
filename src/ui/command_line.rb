require_relative "../model/model"

class CommandLine
  
  def initialize 
     reset
  end

  def reset
    @interpolator = Interpolator.new
    @recalculate = false
  end
  
  
  def exec_command input
    
    command, *params = input.split(/\s/)
    exit = false
    begin
      
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
        when /help/
          help
        else
          puts "No existe el comando. Para ver los comandos, use help"
      end   
      
    rescue Exception=>msg
      puts msg.to_s.gsub "_", " "
    end
  
    abort("Adios!") if exit
  end
    
  def start
      
    help
    
    loop do 
      print "\n> "
      exec_command gets.chop
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
    

  def parse_point string

      point = string.split(",").map {|c| Float(c)} 
      raise Exception.new(:invalid_point_format) if point.length!=2     
      Point.new(point)
  end
  
  def add params
    new_points = []
    params.each { |param| new_points << parse_point(param)}
    new_points.each {|p| @interpolator.add_point p}
    interpolate if @recalculate
  end

  
  def rm params
    points = []
    params.each { |param| points << parse_point(param)}
    points.each{|p| @interpolator.remove_point p}
    interpolate if @recalculate
  end
  
  
  def interpolate 
     puts "Los polinomios no debieron recalcularse" unless @interpolator.interpolate 
     puts @interpolator.progressive_polynomial
     puts @interpolator.regressive_polynomial
     @recalculate = true
  end
  
  
  def calculate params
    puts "No implementado. Evalua el polinomio en #{parse_point params}" 
  end
  
  
  def points
    puts @interpolator.points.length > 0? "#{@interpolator.points*",\n"}" : "No se ingresaron puntos."
  end
  
  def clear
    reset
    puts "Se eliminaron todos los puntos."
  end
  
end

