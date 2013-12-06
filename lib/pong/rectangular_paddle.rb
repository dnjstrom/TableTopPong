require 'pong/paddle'

module Pong
class RectangularPaddle < Paddle
  def initialize(window)
    super window

    @width = 200
    @height = 200

    @image = Gosu::Image.new(window, "media/img/rectangular_paddle.png", false)
    @image_disabled = Gosu::Image.new(window, "media/img/rectangular_paddle-disabled.png", false)

    @body.object = self

    # Define the rectangular shape
    verts = [CP::Vec2.new(0,@height), CP::Vec2.new(@width,@height),
             CP::Vec2.new(@width,0), CP::Vec2.new(0,0) ]

    CP::recenter_poly(verts)
    @shape = CP::Shape::Poly.new(@body, verts, CP::Vec2.new(0,0))
    @shape.layers = CP::ALL_LAYERS
    @shape.u = 0.0 # friction coefficient
    @shape.e = 1.0 # elasticity

    @shape.collision_type = :paddle

    @space.add_collision_func(:paddle, :paddle, &nil)
    @space.add_body(@body)
    @space.add_shape(@shape)
  end

  def draw(visible = true)
    image = if @active then @image else @image_disabled end
    image.draw_rot(@body.p.x, @body.p.y, 1, @body.a) if visible
  end
end
end