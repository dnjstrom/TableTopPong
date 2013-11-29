module Pong
class Paddle
	attr_accessor :x, :y, :rotation, :score

	def initialize(x, y, rotation)
		setPosition(x, y)
		@rotation = rotation
		@score = 0
	end

	def increaseScore
		@score += 1
	end

	def setPosition(x, y)
		@x = x
		@y = y
	end
end
end