require 'pong/paddle'

module Pong
class CircularPaddle < Paddle
  def initialize(window)
    super window

    @width = 200
    @height = 200

    @image = Gosu::Image.new(window, "media/img/circular_paddle.png", false)

    @body.object = self

    # Define the rectangular shape
    @shape = CP::Shape::Circle.new(@body, @width/2.0, Vec2.new(0,0))
    @shape.layers = CP::ALL_LAYERS
    @shape.u = 0.0 # friction coefficient
    @shape.e = 1.0 # elasticity

    @shape.collision_type = :paddle

    @space.add_collision_func(:paddle, :paddle, &nil)
    @space.add_body(@body)
    @space.add_shape(@shape)
  end

  def draw(visible = true)
    @image.draw_rot(@body.p.x, @body.p.y, 1, @body.a) if visible
  end
end
end