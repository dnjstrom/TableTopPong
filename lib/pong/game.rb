require 'ball'
require 'paddle'

module Pong
class Game
	WIDTH = 1000
	HEIGHT = 800


	paddle1 = Paddle.new(20, HEIGHT / 2, 0)
	paddle2 = Paddle.new(WIDTH - 20, HEIGHT / 2, 0)

	ball = Ball.new(WIDTH / 2, HEIGHT / 2, 20, 5, 5)
end
end