require 'pong/ball'
require 'pong/player'
require 'pong/rectangular_paddle'
require 'pong/circular_paddle'
require 'pong/database'

require 'tuio-ruby'
require 'rbconfig'
require 'gosu'
require 'chipmunk'

module Pong
	Vec2 = CP::Vec2

class Game < Gosu::Window
	attr_reader :WIDTH, :HEIGHT, :HOME_WIDTH, :space

	def initialize(options = {})

    db = Database.new
    @main = db.connect :main
    @config = db.connect :config

    @WIDTH = get_config :width, 1024, options
    @HEIGHT = get_config :height, 768, options
    @HEIGHT = get_config :height, 768, options

		@HOME_WIDTH = @config.get :home_width, @WIDTH / 4

		@config_state = 0

		#@HOME_COLOR_GREEN = Gosu::Color.new(255,45,240,65)
		@HOME_COLOR_GREEN = Gosu::Color.new(255,0,0,0)
		#@HOME_COLOR_RED = Gosu::Color.new(255,255,0,0)
		@HOME_COLOR_RED = Gosu::Color.new(255,0,0,0)
		@PLAYER1_CURRENT_COLOR = @HOME_COLOR_GREEN
		@PLAYER2_CURRENT_COLOR = @HOME_COLOR_GREEN

		super @WIDTH, @HEIGHT, get_config(:fullscreen, false, options)

		#Initial cam configuration
		@cam_left = @config.get :cam_left, 1
		@cam_top = @config.get :cam_top, 1
		@cam_right = @config.get :cam_right, 0
		@cam_bottom = @config.get :cam_bottom, 0

		@cam_x = @cam_y = 0
		@config_state = 0
		@visible_paddles = true

		@info_first = ""
		@info_second = ""
		@big_info = ""
    @font = Gosu::Font.new(self, Gosu::default_font_name, 40)
    @font_big = Gosu::Font.new(self, Gosu::default_font_name, 100)

		self.caption = "TableTop Pong"
		@background_image = Gosu::Image.new(self, "media/img/background.png", true)

		# Time increment over which to apply a physics step
    @dt = (1.0/60.0)

		@space = CP::Space.new
    @space.gravity = Vec2.new(0.0, 0.0)

		@target = Gosu::Image.new(self, "media/img/target.png", false)

		@ball = Ball.new self

		@paddles = {0 => RectangularPaddle.new(self).warp(-100, -100),
								1 => RectangularPaddle.new(self).warp(-100, -100),
								2 => CircularPaddle.new(self).warp(-100, -100),
								3 => CircularPaddle.new(self).warp(-100, -100)}

		@left_player = Player.new("Left Player", @paddles[2])
		@right_player = Player.new("Right", @paddles[3])

		@paddle_last_moved = 0

		@isStarting = true

		initTracker

    db = Database.new

    direction = if rand(2) > 0 then 1 else -1 end
    restart direction
	end

	def get_config(option, default, options)
		if options[option]
			options[option]
		else
			@config.get option, default
		end
	end

	def restart(direction = 1)
		@isStarting = true
		@ball.reset(direction)
		@ball.stop

		x = Thread.new do
			@big_info = "Ready"
			sleep 1

			@big_info = "Set"
			sleep 1

			@big_info = "Go!"
			@ball.play
			@isStarting = false
			sleep 0.5

			@big_info = ""
		end
	end

	def update
		# Move ball
		@space.step(@dt)
		@ball.move

		# Move debugger paddle
		#@paddles[2].warp(mouse_x, mouse_y)

		#Check score
		if @ball.p.x < 0
			@right_player.score += 1
			restart -1
		elsif @ball.p.x > @WIDTH
			@left_player.score += 1
			restart 1
		end
	end


	def draw
		@background_image.draw(0, 0, 0)

		@ball.draw

		@paddles.each { |id, paddle| paddle.draw }

		# Info text
		@font.draw(@info_first, 10, @HEIGHT-30, 100, 1.0, 1.0, 0xff000000)
		@font.draw(@info_second, 10, @HEIGHT-50, 100, 1.0, 1.0, 0xff000000)
		@font_big.draw_rel(@big_info, @WIDTH/2, 50, 100, 0.5, 0, 1, 1, 0xff000000)

		#Pause text
		@font_big.draw_rel("Game Paused", @WIDTH/2, @HEIGHT/2, 100, 0.5, 0, 1, 1, 0xff000000) if @ball.paused? && !@isStarting

		# Score
		@font.draw_rel("#{@left_player.score} - #{@right_player.score}", @WIDTH/2, 20, 100, 0.5, 0, 1, 1, 0xff000000)

		# Target for configuration

		case @config_state
		when 1
			@target.draw_rot(@WIDTH / 4, (@HEIGHT / 4) * 3, 1, 0)
		when 2
			@target.draw_rot((@WIDTH / 4)*3, @HEIGHT / 4, 1, 0)
		end

		#Home player 1
		#home_color = if @left_player.paddle.active? then @HOME_COLOR_GREEN else @HOME_COLOR_RED end
		#draw_quad(0, 0, home_color, 
		#					@HOME_WIDTH, 0, home_color, 
		#					0, @HEIGHT, home_color, 
		#					@HOME_WIDTH, @HEIGHT, home_color,
		#					0)

		#Home player 2
		#home_color = if @right_player.paddle.active? then @HOME_COLOR_GREEN else @HOME_COLOR_RED end
		#draw_quad(@WIDTH - @HOME_WIDTH, 0, home_color, 
		#					@WIDTH, 0, home_color, 
		#					@WIDTH - @HOME_WIDTH, @HEIGHT, home_color, 
		#					@WIDTH, @HEIGHT, home_color,
		#					0)
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
			unless @config_state == 0
				@info_first = ""
				@config_state = 0
			else
				close
			end
		when Gosu::KbReturn
			@ball.stop 
			configure_cam
		when Gosu::KbSpace
			if @config_state == 0
				@ball.toggleStop unless @isStarting
			end
		when Gosu::KbD
			@visible_paddles = !@visible_paddles
		end
  end

private

	def configure_cam
		case @config_state
		when 0 
			@info_first = "Position your marker over the dot."
		when 1 
			@a = Point.new @cam_x, @cam_y
			@info_first = "Position your marker over the second dot."
		when 2 
			@b = Point.new @cam_x, @cam_y
			@info_first = ""

			calculate_bounds

			puts "Configuration"
			puts "============="
			puts "Right: #{@cam_right}"
			puts "Left: #{@cam_left}"
			puts "Top: #{@cam_top}"
			puts "Bottom: #{@cam_bottom}"
		end

		@config_state = (@config_state + 1) % 3
	end

	def calculate_bounds
		a = Point.new @WIDTH / 4, (@HEIGHT / 4) * 3
		b = Point.new (@WIDTH / 4) * 3, @HEIGHT / 4

		kx = (@b.x * a.x - @a.x * b.x) / (@b.x - @a.x).to_f
		x = (a.x - kx) / @a.x.to_f

		ky = (@b.y * a.y - @a.y * b.y) / (@b.y - @a.y).to_f
		y = (a.y - ky) / @a.y.to_f

		left = (0-kx) / x.to_f
		right = (@WIDTH-kx) / x.to_f
		top =  (0-ky) / y.to_f
		bottom = (@HEIGHT-ky) / y.to_f

		@cam_left = @config.set :cam_left, left unless left.nan?
		@cam_right = @config.set :cam_right, right unless right.nan?
		@cam_top = @config.set :cam_top, top unless top.nan?
		@cam_bottom = @config.set :cam_bottom, bottom unless bottom.nan?
	end

	def insideHome(paddle, from, to)
		if paddle.pos.x.between?(from, to) && paddle.pos.y.between?(0 - (paddle.HEIGHT / 2.0), @HEIGHT + (paddle.HEIGHT / 2.0))
			paddle.active = true
		else
			paddle.active = false
		end
	end

	def track(obj)
			paddle = @paddles[obj.fiducial_id]

			if paddle
				#puts "#{obj.fiducial_id}: #{obj.x_pos}, #{obj.y_pos}" # For perfomance **Do _not_ remove**
				sleep 0.0015

				x = convert_range obj.x_pos, @cam_left, @cam_right, 0, @WIDTH
				y = convert_range obj.y_pos, @cam_top, @cam_bottom, 0, @HEIGHT

				paddle.warp(x, y)


				unless @config_state == 0
					@info_second = "(x=#{obj.x_pos.round(2)} y=#{obj.y_pos.round(2)})"
				else
					@info_second = ""
				end
				
				@cam_x = obj.x_pos
				@cam_y = obj.y_pos

			end
	end

	def initTracker
		@tc = TuioClient.new

		@tc.on_object_creation do | paddle |
			track paddle
		end

		@tc.on_object_update do | paddle |
			track paddle
		end

		@tc.on_object_removal do | paddle |
			track paddle
		end
	end

	def convert_range(value, from_min, from_max, to_min, to_max)
		ratio = (value - from_min) / (from_max - from_min).to_f
		to_min + (to_max - to_min) * ratio
	end

	class Point
		attr_accessor :x, :y

		def initialize(x, y)
			@x = x
			@y = y
		end
	end
end
end
