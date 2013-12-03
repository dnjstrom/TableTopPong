require 'vector'

module Pong
class Ball
	attr_accessor :x, :y, :vel_x, :vel_y
	attr_reader :radius

	@@radius = 35

	def initialize(window)
		@window = window
		@image = Gosu::Image.new(window, "media/img/ball.png", false)

		space = window.space

    @body = CP::Body.new(1, CP::INFINITY)
    @body.object = self
    @body.p = CP::Vec2.new(0, 0)
    @body.v = CP::Vec2.new(400, 200)
    #@body.v_limit = 500
    shape = CP::Shape::Circle.new(@body, @@radius, CP::Vec2.new(0.0,0.0))
    shape.u = 0.0 # friction coefficient
    shape.e = 1.0 # elasticity
    #shape.collision_type = :player

    space.add_body(@body)
    space.add_shape(shape)
	end

	def self.radius
		@@radius
	end

	def warp(x, y)
    @body.p.x, @body.p.y = x, y
  end

	def move
    #@body.p.x += @body.v.x
    #@body.p.y += @body.v.y

		# Ball hits top or bottom wall
		if @body.p.y < @@radius || @body.p.y > (@window.HEIGHT - @@radius)
			@body.v.y *= -1
		end

		if @body.p.x < @@radius || @body.p.x > (@window.WIDTH - @@radius)
			@body.v.x *= -1
		end
  end

  def draw
    @image.draw_rot(@body.p.x, @body.p.y, 1, @body.a)
  end
end
end