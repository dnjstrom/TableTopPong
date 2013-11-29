require 'ball'
require 'paddle'

module Pong
class Game
	WIDTH = 1000
	HEIGHT = 800

	tracker = Tracker.new

	paddle1 = Paddle.new(20, HEIGHT / 2, 0)
	paddle2 = Paddle.new(WIDTH - 20, HEIGHT / 2, 0)

	ball = Ball.new(WIDTH / 2, HEIGHT / 2, 20, 5, 5)

	# Start tracker and identify blocks?

	begin # Game loop
		# Check input

		# Move paddles
		# Move ball

		# Check collisions
		# Check score

		# Draw GUI
	end until true
end
end