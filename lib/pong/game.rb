require 'pong/ball'
require 'pong/player'
require 'pong/rectangular_paddle'


require 'tuio-ruby'
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
		@HOME_WIDTH = 150
		@config_state = 0
		@HOME_COLOR_GREEN = Gosu::Color.new(255,45,240,65)
		@HOME_COLOR_RED = Gosu::Color.new(255,255,0,0)
		@PLAYER1_CURRENT_COLOR = @HOME_COLOR_GREEN
		@PLAYER2_CURRENT_COLOR = @HOME_COLOR_GREEN

		super @WIDTH, @HEIGHT, false

		initTracker

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
	end

	def update
		# Move ball
		@space.step(@dt)
		@ball.move
		#@paddles.each { |id, paddle| paddle.warp(mouse_x, mouse_y)}
		@paddles[0].warp(mouse_x, mouse_y)
		insideHome(@paddles[0], 0, @HOME_WIDTH)

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
		
		draw_quad(0, 0, @PLAYER1_CURRENT_COLOR, 
							@HOME_WIDTH, 0, @PLAYER1_CURRENT_COLOR, 
							0, @HEIGHT, @PLAYER1_CURRENT_COLOR, 
							@HOME_WIDTH, @HEIGHT, @PLAYER1_CURRENT_COLOR,
							0)
		draw_quad(@WIDTH - @HOME_WIDTH, 0, @PLAYER2_CURRENT_COLOR, 
							@WIDTH, 0, @PLAYER2_CURRENT_COLOR, 
							@WIDTH - @HOME_WIDTH, @HEIGHT, @PLAYER2_CURRENT_COLOR, 
							@WIDTH, @HEIGHT, @PLAYER2_CURRENT_COLOR,
							0)
	end

	def start
		#@tc.start
		self.show
	end

	def button_down(id)
    if id == Gosu::KbEscape
      close
    elsif Gosu::KbReturn

    	case @config_state
    	when 0 
    		puts "Put your marker in the right-most position and hit enter."
    	when 1 
    		puts "Put your marker in the left-most position and hit enter."
    	when 2 
    		puts "Put your marker in the top-most position and hit enter."
    	when 3 
    		puts "Put your marker in the bottom-most position and hit enter."
    	when 4 
    		puts "Configuration done"
    	end

    	@config_state = (@config_state + 1) % 5
    end
  end

private
	def insideHome(paddle, from, to)
		if paddle.pos.x.between?(from, to) && paddle.pos.y.between?(0, @HEIGHT)
			paddle.activate
		else
			paddle.deactivate
		end

		paddle.active
	end

	def initTracker
		@tc = TuioClient.new

		@tc.on_object_creation do | to |
			@paddles[to.fiducial_id].activate
		end
		@tc.on_object_update do | to |
			paddle = @paddles[to.fiducial_id]

			if paddle
				if paddle == @player1.paddle
					if insideHome(paddle, 0, @HOME_WIDTH) 
						@PLAYER1_CURRENT_COLOR = @HOME_COLOR_GREEN
					else
						@PLAYER1_CURRENT_COLOR = @HOME_COLOR_RED
					end
				else 
					if insideHome(paddle, @WIDTH - @HOME_WIDTH, @WIDTH)
						@PLAYER2_CURRENT_COLOR = @HOME_COLOR_GREEN
					else
						@PLAYER2_CURRENT_COLOR = @HOME_COLOR_RED
					end
				end
				puts "Paddle #{to.fiducial_id}: x=#{to.x_pos} y=#{to.y_pos}"
				paddle.warp(to.x_pos * @WIDTH, to.y_pos * @HEIGHT) 
			end
		end


		@tc.on_object_removal do | to |
			@paddles[to.fiducial_id].deactivate
		end
	end

	def convert_range(from_min, from_max, to_min, to_max)
		ratio = from_min / from_max
		to_min + (to_max - to_min) * ratio
	end
end
end