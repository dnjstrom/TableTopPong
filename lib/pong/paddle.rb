module Pong
	class Paddle
		attr_accessor :x, :y, :rotation, :score

		def initialize(x, y, rotation)
			@x = x
			@y = y
			@rotation = rotation
		end

		def increaseScore
			@score += 1
		end

		def setPosition(x, y)
			@x = x;
			@y = y;
		end
	end
end