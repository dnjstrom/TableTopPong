module Pong
class Paddle
	def initialize(window)
		@window = window
    @space = window.space
    @active = true

    @body = CP::Body.new(CP::INFINITY, CP::INFINITY)
    @body.object = self
    @body.p = Vec2.new(0, 0)
    @body.v_limit = 0
	end

  def height
    @height
  end

  def width
    @width
  end

  def pos
    @body.p
  end

  def active?
    @active
  end

  def warp(x, y)
    @body.p.x = x
    @body.p.y = y
    self
  end
  
  def active(state)
  	@active = state
  	@shape.layers = if state then CP::ALL_LAYERS else 2 end
  	self
  end
end
end