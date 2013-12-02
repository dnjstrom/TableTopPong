require 'pong/ball'
require 'pong/player'
require 'pong/rectangular_paddle'


require 'tuio-ruby'
require 'vector'
require 'rbconfig'
require 'gosu'
require 'chipmunk'

module Pong
	Vec2 = CP::Vec2

class Game < Gosu::Window
	attr_reader :WIDTH, :HEIGHT, :HOME_WIDTH, :space


	def initialize
		@WIDTH = 640
		@HEIGHT = 360
		@HOME_WIDTH = 100

		super @WIDTH, @HEIGHT, false

		initTracker

		self.caption = "TableTop Pong"

		# Time increment over which to apply a physics step
    @dt = (1.0/60.0)

		#@paddles = {0 => RectangularPaddle.new(10, 40), 1 => RectangularPaddle.new(10, 40)}

		#@player1 = Player.new("Daniel", @paddles[0])
		#@player2 = Player.new("Isak", @paddles[1])

		#@ball = Ball.new(@WIDTH / 2, @HEIGHT / 2, 20, 15, 15)

		@space = CP::Space.new
    @space.gravity = Vec2.new(0.0, 0.0)

		@ball = Ball.new self
    @ball.warp 200, 100

    @paddle = RectangularPaddle.new self
	end

	def update
		# Move ball
		@space.step(@dt)
		@ball.move

		#puts "x = #{@ball.position.x}, y = #{@ball.position.y}"

		# Check score
		# if @ball.x < 0
		# 	@player1.score += 1
		# elsif @ball.x > @WIDTH
		# 	@player2.score += 1
		# end

		# Draw GUI
	end

	def draw
		@ball.draw
		@paddle.draw
	end

	def start
		@tc.start
		self.show
	end

	def button_down(id)
    if id == Gosu::KbEscape
      close
    end
  end

private
	def insideHome(paddle, from, to)
		if paddle.position.x.between?(from, to) && paddle.position.y.between?(0, @HEIGHT)
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
				insideHome(paddle, 0, @HOME_WIDTH)
			else 
				insideHome(paddle, @WIDTH - @HOME_WIDTH, @WIDTH)
			end

			paddle.position.set(to.x_pos, to.y_pos)
		end

		@tc.on_object_removal do | to |
			@paddles[to.fiducial_id].deactivate
		end
	end
end
end