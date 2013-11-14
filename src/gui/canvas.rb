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
  

  def resize
  	unless @interpolator.points.empty?
		points = @interpolator.points
		min_size = 100
		extra_size = 50

		pointsX = points.map{|p| p.x.abs}
		maxx = pointsX.max.to_int + 1
		maxx = min_size if maxx < min_size

		pointsY = points.map{|p| p.y.abs}
		maxy = pointsY.max.to_int + 1
		maxy = min_size if maxy < min_size

		@gw = 2 * maxx + extra_size
		@gh = 2 * maxy + extra_size

		@pw = @gw * @zoom
		@ph = @gh * @zoom

		self.set_size @pw, @ph
end
  end

  def paintComponent g
    super
    self.draw_function g if @interpolator.polynomial
  end
  
  
  

  def drawLine g, x1, y1, x2, y2
  	rx = @pw / @gw #relacion x
  	ry = @ph / @gh #relacion y
  	g.drawLine x1*rx, y1*ry, x2*rx, y2*ry
  end

  def drawPoint g, x, y
    drawLine g, x, y, x, y
  end

  def drawString g, str, x, y
  	g.scale 1, -1
  	rx = @pw / @gw #relacion x
  	ry = @ph / @gh #relacion y
  	g.drawString str, x*rx, -y*ry
  	g.scale 1, -1
  end



  def draw_function g
    #user def constants
    color_back = color 100, 100, 100
    color_grid = color 150, 150, 150
    grid_size = 10
    color_axis = color 0, 100, 255
    color_function = color 255, 255, 255
    color_point = color 230, 0, 0

    #other constants
    hw = @gw / 2
    hh = @gh / 2
    
    self.setBackground color_back
    
    #nos guardamos la antitransformacion
    at = g.getTransform
    #transformamos a coordenadas cartesianas
    g.translate @pw/2, @ph/2
    g.scale 1, -1
    
    #dibujamos una grilla
    gridw = (hw / grid_size).to_int
    gridh = (hh / grid_size).to_int
    for i in -grid_size..grid_size
      g.setColor color_grid
      drawLine g, gridw * i, -hh, gridw * i, hh
      drawLine g, -hw, gridh * i, hw, gridh * i
  
      g.setColor  color_axis
      drawLine g, gridw * i, 3, gridw * i, -3
      drawLine g, 3, gridh * i, -3, gridh * i
    end
    
    #dibujamos los ejes
    drawLine g, 0, -hh, 0, hh
    drawLine g, -hw, 0, hw, 0
    
    #imprimimos texto en los ejes
    g.setColor color_axis
    drawString g, "x", hw - 10, -10
    drawString g, "P(x) = y", -70, hh - 10
    for i in 1..grid_size
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
    
    #marcamos los puntos que ingresamos
    points = @interpolator.points
    g.setColor color_point
    for p in points
      drawLine g, 0, p.y, p.x, p.y
      drawLine g, p.x, 0, p.x, p.y
    end
    
    #dibujamos la funcion
    g.setColor color_function
    last_x = -hw
    for x in -hw..hw
      
      y = @interpolator.evaluate x
      last_y = y if x == -hw
      

      shh = -hh

      if (y > hh) ^ (last_y > hh)
        dy = y - last_y
        t = (hh - last_y) / dy
        dx = x - last_x
        yt = hh
        xt = last_x + t * dx
        drawLine g, last_x, last_y, xt, yt if y > hh
        drawLine g, xt, yt, x, y if last_y > hh
      elsif (y < shh) ^ (last_y < shh)
        dy = y - last_y
        t = (shh - last_y) / dy
        dx = x - last_x
        yt = shh
        xt = last_x + t * dx
        drawLine g, last_x, last_y, xt, yt if y < shh
        drawLine g, xt, yt, x, y if last_y < shh
      elsif y.abs < hh && last_y.abs < hh
        drawLine g, last_x, last_y, x, y
      end
      

      last_x = x
      last_y = y
      
    end
    
    #imprimimos los puntos
    g.setColor color_point
    for p in points
      drawString g, p.to_s, p.x, p.y
    end
    
    #antitransformamos
    g.setTransform at
  end
  
  def set_size w, h
    self.setPreferredSize Dimension.new(w, h)
  end
end