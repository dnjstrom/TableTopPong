module Pong
class Player
	attr_accessor :name, :score, :paddle

	def initialize(name, paddle, score = 0)
		@name = name
		@score = score
		@paddle = paddle
	end
end
end