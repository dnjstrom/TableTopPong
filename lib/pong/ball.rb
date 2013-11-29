module Pong
	class Ball
		attr_accessor :x, :y, :radius, :dx, :dy

		def initialize(x, y, radius, dx, dy)
			setPosition(x, y);
			@radius = radius
			@dx = dx
			@dy = dy
		end

		def setPosition(x, y)
			@x = x;
			@y = y;
		end

		def move
			setPosition(x + dx, y + dy)
		end
	end
end