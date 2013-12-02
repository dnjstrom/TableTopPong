require 'vector'

module Pong
class Ball
	attr_accessor :x, :y, :vel_x, :vel_y
	attr_reader :radius

	@@radius = 35

	def initialize(window)
		@window = window
		@image = Gosu::Image.new(window, "media/img/ball.png", false)

		@x = @y = 0.0
		@vel_x = @vel_y = 4
	end

	def self.radius
		@@radius
	end

	def warp(x, y)
    @x, @y = x, y
  end

	def move
    @x += @vel_x
    @y += @vel_y

		# Ball hits top or bottom wall
		if @y < @@radius || @y > (@window.HEIGHT - @@radius)
			@vel_y *= -1
		end

		if @x < @@radius || @x > (@window.WIDTH - @@radius)
			@vel_x *= -1
		end
  end

  def draw
    @image.draw_rot(@x, @y, 1, 0)
  end
end
end