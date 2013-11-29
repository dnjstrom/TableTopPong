require 'pong/ball'
require 'pong/tracker'
require 'pong/player'
require 'pong/rectangular_paddle'

require 'vector'

module Pong
class Game
	WIDTH = 1000
	HEIGHT = 800
	HOME_WIDTH = 100

	def initialize
		initTracker

		@paddles = {0 => RectangularPaddle.new(10, 40), 1 => RectangularPaddle.new(10, 40)}

		@player1 = Player.new("Daniel", @paddles[0])
		@player2 = Player.new("Isak", @paddles[1])

		@ball = Ball.new(WIDTH / 2, HEIGHT / 2, 20, 15, 15)
	end

	def start
		@tc.start

		nextTime = Time.now

		loop do # Game loop
			if Time.now > nextTime
				nextTime = Time.now + 0.033 # 33 fps

				# Move ball
				@ball.move!

				# Check collisions
				

				# Ball hits top or bottom wall
				if @ball.position.y < 0 || @ball.position.y > HEIGHT
					@ball.direction.flipY
				end

				if @ball.position.x < 0 || @ball.position.x > WIDTH
					@ball.direction.flipX
				end

				puts "x = #{@ball.position.x}, y = #{@ball.position.y}"

				# Check score
				# if @ball.x < 0
				# 	@player1.score += 1
				# elsif @ball.x > WIDTH
				# 	@player2.score += 1
				# end

				# Draw GUI
			end
		end
	end

private
	def insideHome(paddle, from, to)
		if paddle.position.x.between?(from, to) && paddle.position.y.between?(0, HEIGHT)
			paddle.activate
		else
			paddle.deactivate
		end
	end

	def initTracker
		@tc = TuioClient.new

		@tc.on_object_creation do | to |
			@paddles[to.fiducial_id].activate
		end

		@tc.on_object_update do | to |
			paddle = @paddles[to.fiducial_id]

			if paddle == @player1.paddle
				insideHome(paddle, 0, HOME_WIDTH)
			else 
				insideHome(paddle, WIDTH - HOME_WIDTH, WIDTH)
			end

			paddle.position.set(to.x_pos, to.y_pos)
		end

		@tc.on_object_removal do | to |
			@paddles[to.fiducial_id].deactivate
		end
	end
end
end