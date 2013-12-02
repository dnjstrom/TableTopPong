require 'vector'

module Pong
class Ball
	attr_accessor :position, :radius, :direction

	def initialize(x, y, radius, dx, dy)
		@position = Vector.new(x, y)
		@radius = radius
		@direction = Vector.new(dx, dy)
	end

	def move
		@position.add!(@direction.x, @direction.y)
	end
end
end