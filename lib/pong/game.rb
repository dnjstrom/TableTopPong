require 'pong/ball'
require 'pong/player'
require 'pong/rectangular_paddle'
require 'pong/database'

require 'tuio-ruby'
require 'rbconfig'
require 'gosu'
require 'chipmunk'

module Pong
	Vec2 = CP::Vec2

class Game < Gosu::Window
	attr_reader :WIDTH, :HEIGHT, :HOME_WIDTH, :space


	def initialize
    db = Database.new
    @main = db.connect :main
    @config = db.connect :config

		@WIDTH = @config.get :window_width, 640
		@HEIGHT = @config.get :window_height, 360
		@HOME_WIDTH = @config.get :home_width, 150

		super @WIDTH, @HEIGHT, false

		#Initial cam configuration
		@cam_left = @config.get :cam_left, 1
		@cam_top = @config.get :cam_top, 1
		@cam_right = @config.get :cam_right, 0
		@cam_bottom = @config.get :cam_bottom, 0

		@cam_x = @cam_y = 0

		@config_state = 0

		@info_first = ""
		@info_second = ""
    @font = Gosu::Font.new(self, Gosu::default_font_name, 20)

		self.caption = "TableTop Pong"

		# Time increment over which to apply a physics step
    @dt = (1.0/60.0)

		@space = CP::Space.new
    @space.gravity = Vec2.new(0.0, 0.0)
    @text = Gosu::Font.new(self, Gosu::default_font_name, 20)

		@ball = Ball.new self

		@paddles = {0 => RectangularPaddle.new(self).warp(-100, -100),
								1 => RectangularPaddle.new(self).warp(-100, -100)}

		@player1 = Player.new("Daniel", @paddles[0])
		@player2 = Player.new("Isak", @paddles[1])

		@paddle_last_moved = 0

		initTracker
		
    db = Database.new
	end

	def update
		# Move ball
		@space.step(@dt)
		@ball.move
		#@paddles.each { |id, paddle| paddle.warp(mouse_x, mouse_y)}
		# @paddles[0].warp(mouse_x, mouse_y)
		# insideHome(@paddles[0], 0, @HOME_WIDTH)

		#Check score
		if @ball.p.x < 0
			@player2.score += 1
			@ball.reset(-1)
		elsif @ball.p.x > @WIDTH
			@player1.score += 1
			@ball.reset(1)
		end

		# Draw GUI
	end

	def draw
		@ball.draw
		@paddles.each { |id, paddle| paddle.draw if paddle.active }
		@text.draw_rel("#{@player1.score} - #{@player2.score}", @WIDTH/2, 5, 1, 0.5, 0)
		@font.draw(@info_first, 10, 10, 100, 1.0, 1.0, 0xffffffff)
		@font.draw(@info_second, 10, 30, 100, 1.0, 1.0, 0xffffffff)
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
			configure_cam
		end
  end

private

	def configure_cam
		case @config_state
		when 0 
			@info_first = "Put your marker in the right-most position and hit enter."
		when 1 
			@cam_right = @config.set :cam_right, @cam_x
			@info_first = "Put your marker in the left-most position and hit enter."
		when 2 
			@cam_left = @config.set :cam_left, @cam_x
			@info_first = "Put your marker in the top-most position and hit enter."
		when 3 
			@cam_top = @config.set :cam_top, @cam_y
			@info_first = "Put your marker in the bottom-most position and hit enter."
		when 4 
			@cam_bottom = @config.set :cam_bottom, @cam_y
			@info_first = ""

			puts "Configuration"
			puts "============="
			puts "Right: #{@cam_right}"
			puts "Left: #{@cam_left}"
			puts "Top: #{@cam_top}"
			puts "Bottom: #{@cam_bottom}"
		end
		@config_state = (@config_state + 1) % 5
	end

	def insideHome(paddle, from, to)
		if paddle.pos.x.between?(from, to) && paddle.pos.y.between?(0, @HEIGHT)
			paddle.activate
		else
			paddle.deactivate
		end
	end

	def initTracker
		@tc = TuioClient.new

		@tc.on_object_creation do | to |
		#	@paddles[to.fiducial_id].activate
		end

		@tc.on_object_update do | to |
			paddle = @paddles[to.fiducial_id]

			if paddle
				if paddle == @player1.paddle
					insideHome(paddle, 0, @HOME_WIDTH)
				else 
					insideHome(paddle, @WIDTH - @HOME_WIDTH, @WIDTH)
				end
				puts "Paddle #{to.fiducial_id}: x=#{to.x_pos} y=#{to.y_pos}"
				paddle.warp(to.x_pos * @WIDTH, to.y_pos * @HEIGHT) 
			end

			if paddle
				x = convert_range to.x_pos, @cam_left, @cam_right, 0, @WIDTH
				y = convert_range to.y_pos, @cam_top, @cam_bottom, 0, @HEIGHT

				paddle.warp(x, y)

				unless @config_state == 0
					@info_second = "(x=#{to.x_pos.round(2)} y=#{to.y_pos.round(2)})"
				else
					@info_second = ""
				end

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