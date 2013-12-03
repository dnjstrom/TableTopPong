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

		#Initial cam configuration
		@cam_left = @cam_top = 1
		@cam_right = @cam_bottom = 0
		@cam_x = @cam_y = 0

		@config_state = 0

		@info = ""
    @font = Gosu::Font.new(self, Gosu::default_font_name, 20)

		initTracker

		self.caption = "TableTop Pong"

		# Time increment over which to apply a physics step
    @dt = (1.0/60.0)

		#@player1 = Player.new("Daniel", @paddles[0])
		#@player2 = Player.new("Isak", @paddles[1])

		#@ball = Ball.new(@WIDTH / 2, @HEIGHT / 2, 20, 15, 15)

		@space = CP::Space.new
    @space.gravity = Vec2.new(0.0, 0.0)

		@ball = Ball.new self
    @ball.warp 200, 100

		@paddles = {0 => RectangularPaddle.new(self).warp(-100, -100),
								1 => RectangularPaddle.new(self).warp(-100, -100)}

		@paddle_last_moved = 0

    #@paddle = RectangularPaddle.new self

	end

	def update
		# Move ball
		@space.step(@dt)
		@ball.move
		#@paddle.warp(mouse_x, mouse_y)

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
		@paddles.each { |id, paddle| paddle.draw }
		@font.draw(@info, 10, 10, 100, 1.0, 1.0, 0xffffffff)
	end

	def start
		@tc.start
		self.show
	end

	def stop
		@tc.stop
	end

	def button_down(id)
		case id
		when Gosu::KbEscape
      close
		when Gosu::KbReturn
    	case @config_state
    	when 0 
    		@info = "Put your marker in the right-most position and hit enter."
    	when 1 
    		@cam_right = @cam_x
    		@info = "Put your marker in the left-most position and hit enter."
    	when 2 
    		@cam_left = @cam_x
    		@info = "Put your marker in the top-most position and hit enter."
    	when 3 
    		@cam_top = @cam_y
    		@info = "Put your marker in the bottom-most position and hit enter."
    	when 4 
    		@cam_bottom = @cam_y
    		@info = ""
    	end
    	@config_state = (@config_state + 1) % 5
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
			#@paddles[to.fiducial_id].activate
		end

		@tc.on_object_update do | to |
			paddle = @paddles[to.fiducial_id]

			#if paddle == @player1.paddle
			#	insideHome(paddle, 0, @HOME_WIDTH)
			#else 
			#	insideHome(paddle, @WIDTH - @HOME_WIDTH, @WIDTH)
			#end

			if paddle

				x = convert_range to.x_pos, @cam_left, @cam_right, 0, @WIDTH
				y = convert_range to.y_pos, @cam_top, @cam_bottom, 0, @HEIGHT

				paddle.warp(x, y)

				#puts "Cam: #{to.fiducial_id}: x=#{to.x_pos} y=#{to.y_pos}"
				#puts "Paddle #{to.fiducial_id}: x=#{x} y=#{y}"

				@cam_x = to.x_pos
				@cam_y = to.y_pos
			end
		end

		@tc.on_object_removal do | to |
			#@paddles[to.fiducial_id].deactivate
		end
	end

	def convert_range(value, from_min, from_max, to_min, to_max)
		ratio = (value - from_min) / (from_max - from_min).to_f
		to_min + (to_max - to_min) * ratio
	end
end
end