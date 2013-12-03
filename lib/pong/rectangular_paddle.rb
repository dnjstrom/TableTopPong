module Pong
class RectangularPaddle
  attr_reader :active

  @@WIDTH = 30
  @@HEIGHT = 100

  def initialize(window)
    @window = window
    @image = Gosu::Image.new(window, "media/img/rectangular_paddle.png", false)

    space = window.space
    @active = false

    @body = CP::Body.new(CP::INFINITY, CP::INFINITY)
    @body.object = self
    @body.p = Vec2.new(0, 0)
    @body.v_limit = 0

    verts = [CP::Vec2.new(0,@@HEIGHT), CP::Vec2.new(@@WIDTH,@@HEIGHT),
     CP::Vec2.new(@@WIDTH,0), CP::Vec2.new(0,0) ]

     CP::recenter_poly(verts)

     @shape = CP::Shape::Poly.new(@body, verts, CP::Vec2.new(0,0))
     @shape.layers = 2
    @shape.u = 0.0 # friction coefficient
    @shape.e = 1.0 # elasticity

    @shape.collision_type = :paddle

    space.add_collision_func(:paddle, :paddle, &nil)
    space.add_body(@body)
    space.add_shape(@shape)
  end

  def draw
    @image.draw_rot(@body.p.x, @body.p.y, 1, @body.a)
  end

  def warp(x, y)
    @body.p.x = x
    @body.p.y = y
    self
  end

  def activate
    @active = true
    @shape.layers = CP::ALL_LAYERS
    self
  end  

  def deactivate
    @active = false
    @shape.layers = 2
    self
  end  

  def pos
    @body.p
  end
end
end