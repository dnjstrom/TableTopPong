require './ball'
require './paddle'
require './tracker'
require 'vector'

module Pong
class Game
	WIDTH = 1000
	HEIGHT = 800
	HOME_WIDTH = 100
	HOME_HEIGHT = HEIGHT

	tracker = Tracker.new

	paddle1 = Paddle.new(20, HEIGHT / 2, 0)
	paddle2 = Paddle.new(WIDTH - 20, HEIGHT / 2, 0)

	ball = Ball.new(WIDTH / 2, HEIGHT / 2, 20, 5, 5)

	# Set identifier to paddle objects

	begin # Game loop
		# Check input, use tracker
		paddle1_new_position = 0
		paddle2_new_position = 0

		# Assure that the paddles are inside the home
		insideHome(paddle1_new_position, paddle2_new_position);

		# Move paddles
		paddle1.setPosition(paddle1_new_position.getX, paddle1_new_position.getY)
		paddle2.setPosition(paddle2_new_position.getX, paddle1_new_position.getY)

		# Move ball
		ball.move

		# Check collisions

		# Change ball direction
		# Ball hits top or bottom wall
		if ball.y < 0 || ball.y > HEIGHT
			ball.invertYDirection
		end

		# Check score
		if ball.x < 0
			player1.increaseScore
		elsif ball.x > WIDTH
			player2.increaseScore
		end

		# Draw GUI
	end until true

	def insideHome(paddle1_new_position, paddle2_new_position)
		if paddle1_new_position.getX > HOME_WIDTH
			paddle1_new_position.x = HOME_WIDTH
		elsif paddle1_new_position.getX < 0
			paddle1_new_position.x = 0
		end

		if paddle1_new_position.getY > HEIGHT
			paddle1_new_position.y = HEIGHT
		elsif paddle1_new_position.getY < 0
			paddle1_new_position.y = 0
		end

		if paddle2_new_position.getX < WIDTH - HOME_WIDTH
			paddle2_new_position.x = WIDTH - HOME_WIDTH
		elsif paddle2_new_position.getX > WIDTH
			paddle2_new_position.x = WIDTH
		end

		if paddle2_new_position.getY > HEIGHT
			paddle2_new_position.y = HEIGHT
		elsif paddle2_new_position.getY < 0
			paddle2_new_position.y = 0
		end
	end

	private :insideHome
end
end