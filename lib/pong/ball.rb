module Pong
class Ball
	attr_reader :radius

	@@radius = 35

	def initialize(window)
		@window = window
		@image = Gosu::Image.new(window, "media/img/ball.png", false)

		space = window.space

    @body = CP::Body.new(1, CP::INFINITY)
    @body.object = self
    reset
    shape = CP::Shape::Circle.new(@body, @@radius, CP::Vec2.new(0.0,0.0))
    shape.u = 0.0 # friction coefficient
    shape.e = 1.0 # elasticity
    shape.layers = 1

    space.add_body(@body)
    space.add_shape(shape)

    @v_backup = Vec2.new(0.0, 0.0)

    @isPaused = false
	end

	def self.radius
		@@radius
	end

	def p
		@body.p
	end

	def warp(x, y)
    @body.p.x, @body.p.y = x, y
  end

	def move
		# Ball hits top or bottom wall
		if @body.p.y < @@radius
			@body.v.y = @body.v.y.abs
		end

		if @body.p.y > (@window.HEIGHT - @@radius)
			@body.v.y = -@body.v.y.abs
		end
  end

  def stop
    @isPaused = true
    @v_backup = Vec2.new(@body.v.x, @body.v.y)
  	@body.v = Vec2.new(0.0, 0.0)
  end

  def play
    @isPaused = false
  	@body.v = @v_backup
  end

  def toggleStop
  	if @isPaused
      play
  	else
      stop
  	end
  end

  def draw
    @image.draw_rot(@body.p.x, @body.p.y, 1, @body.a)
  end

  def reset(multiplier = 1)
  	warp(@window.WIDTH/2,@window.HEIGHT/2)
  	@body.v = CP::Vec2.new(400 * multiplier, 200)
  end	
end
end