include Java

import java.awt.Graphics
import java.awt.Color
import java.awt.Dimension



def color r, g, b
	Color.new r, g, b
end

def sign n
    n / n.abs
end



class Canvas < JPanel
  
  BACKGROUND_COLOR = color 0, 0, 0
  GRID_COLOR = color 0, 100, 0
  AXIS_COLOR = color 0, 255, 0
  FUNCTION_COLOR = color 255, 255, 255
  POINT_COLOR = color 255, 0, 0
  GRID_STD_CELLS = 10

  def setInterpolator interpolator
    @interpolator = interpolator
  end
  
  def setZoom zoom
    @zoom = zoom
  end
  
  def zoomIn
    @zoom = @zoom + 1
  end
  
  def zoomOut
    @zoom = @zoom - 1 if @zoom > 1
  end
  
  def duplicateZoom
    @zoom = @zoom * 2
  end
  

  def refreshSize minw, minh
  	unless @interpolator.points.empty?
  		points = @interpolator.points
  		min_size = 100
  		extra_size = 50

      values = points.map{|p| p.x.abs}
      values.concat(points.map{|p| p.y.abs})
      max = values.max.to_int + 1
      max = min_size if max < min_size

  		@graph_width = 2 * max + extra_size
  		@graph_height = 2 * max + extra_size

  		@panel_width = @graph_width * @zoom
  		@panel_height = @graph_height * @zoom
      @panel_width = minw if @panel_width < minw
      @panel_height = minh if @panel_height < minh

  		self.set_size @panel_width, @panel_height
    end
  end

  def paintComponent g
    super

    return if @interpolator.points.empty?
    #other constants
    @half_width = @graph_width / 2
    @half_height = @graph_height / 2
    
    self.setBackground BACKGROUND_COLOR
    
    #nos guardamos la transformacion
    transformate = g.getTransform
    #transformamos a coordenadas cartesianas
    g.translate @panel_width/2, @panel_height/2
    g.scale 1, -1
    
    draw_grid g

    draw_axis g

    draw_polynomial(g) if @interpolator.polynomial

    draw_points(g) 
    
    #antitransformamos
    g.setTransform transformate

  end
  
  def drawLine g, x1, y1, x2, y2
  	rx = @panel_width / @graph_width #relacion x
  	ry = @panel_height / @graph_height #relacion y
  	g.drawLine x1*rx, y1*ry, x2*rx, y2*ry
    # z = @zoom
    # g.drawLine x1*z, y1*z, x2*z, y2*z
  end

  def drawPoint g, x, y
    drawLine g, x, y, x, y
  end

  def drawString g, str, x, y
  	g.scale 1, -1
  	rx = @panel_width / @graph_width #relacion x
  	ry = @panel_height / @graph_height #relacion y
    g.drawString str, x*rx, -y*ry
   #  z = @zoom
  	# g.drawString str, x*z, -y*z
  	g.scale 1, -1
  end



  def draw_polynomial g
    #dibujamos la funcion
    g.setColor FUNCTION_COLOR
    last_x = -@half_width
    for x in -@half_width..@half_width
      
      y = @interpolator.evaluate x
      last_y = y if x == -@half_width
      
      if (y > @half_height) ^ (last_y > @half_height)
        dy = y - last_y
        t = (@half_height - last_y) / dy
        dx = x - last_x
        yt = @half_height
        xt = last_x + t * dx
        drawLine g, last_x, last_y, xt, yt if y > @half_height
        drawLine g, xt, yt, x, y if last_y > @half_height
      elsif (y < -@half_height) ^ (last_y < -@half_height)
        dy = y - last_y
        t = (-@half_height - last_y) / dy
        dx = x - last_x
        yt = -@half_height
        xt = last_x + t * dx
        drawLine g, last_x, last_y, xt, yt if y < -@half_height
        drawLine g, xt, yt, x, y if last_y < -@half_height
      elsif y.abs < @half_height && last_y.abs < @half_height
        drawLine g, last_x, last_y, x, y
      end
      

      last_x = x
      last_y = y
      
    end
  end

  def draw_grid g
    #dibujamos una grilla
    gridsize = GRID_STD_CELLS #* @zoom
    gridw = (@half_width / gridsize).to_int
    gridh = (@half_height / gridsize).to_int
    for i in -gridsize..gridsize
      g.setColor GRID_COLOR
      drawLine g, gridw * i, -@half_height, gridw * i, @half_height
      drawLine g, -@half_width, gridh * i, @half_width, gridh * i
  
      g.setColor  AXIS_COLOR
      drawLine g, gridw * i, 3, gridw * i, -3
      drawLine g, 3, gridh * i, -3, gridh * i
    end

  end

  def draw_axis g
    gridsize = GRID_STD_CELLS #* @zoom
    gridw = (@half_width / gridsize).to_int
    gridh = (@half_height / gridsize).to_int
    #dibujamos los ejes
    drawLine g, 0, -@half_height, 0, @half_height
    drawLine g, -@half_width, 0, @half_width, 0
    
    #imprimimos texto en los ejes
    g.setColor AXIS_COLOR
    drawString g, "x", @half_width - 10, -10
    drawString g, "P(x) = y", -70, @half_height - 10
    for i in 1..gridsize
      x = gridw * i
      nx = -x
      y = -gridh * i
      ny = -y
      #numeros en el eje x
      drawString g, x.to_s, x, 3
      drawString g, nx.to_s, nx, 3
      #numeros en el eje y
      drawString g, y.to_s, 3, ny
      drawString g, ny.to_s, 3, y
    end
    drawString g, "0", 3, 3
  end
  
  def draw_points g
    #marcamos los puntos que ingresamos
    points = @interpolator.points
    g.setColor POINT_COLOR
    for p in points
      drawLine g, 0, p.y, p.x, p.y
      drawLine g, p.x, 0, p.x, p.y
    end

    #imprimimos los puntos
    g.setColor POINT_COLOR
    for p in points
      drawString g, p.to_s, p.x, p.y
    end
  end

  def set_size w, h
    self.setPreferredSize Dimension.new(w, h)
  end
end