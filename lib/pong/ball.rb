module Pong
class Ball
	attr_accessor :x, :y, :radius, :dx, :dy

	def initialize(x, y, radius, dx, dy)
		setPosition(x, y)
		@radius = radius
		setDirection(dx, dy)
	end

	def setDirection(dx, dy)
		@dx = dx
		@dy = dy
	end

	def invertYDirection()
		@dy *= -1
	end

	def invertXDirection()
		@dx *= -1
	end

	def move
		setPosition(x + dx, y + dy)
	end

	def setPosition(x, y)
		@x = x
		@y = y
	end

	private :setPosition, :setDirection
end
end