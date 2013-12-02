module Pong
class RectangularPaddle

	@@WIDTH = 30
	@@HEIGHT = 100

	def initialize(window)
		@window = window
		@image = Gosu::Image.new(window, "media/img/rectangular_paddle.png", false)

		space = window.space

    # bottom wall
    #rect_shape.collision_type = :wall

    @body = CP::Body.new(CP::INFINITY, CP::INFINITY)
    @body.object = self # user-defined object is this Player
    @body.p = Vec2.new(200, 200)
    @body.v_limit = 0
    #shape = CP::Shape::Segment.new(@body, CP::Vec2.new(@body.p.x, @body.p.y - (@@HEIGHT/2)), CP::Vec2.new(@body.p.x, @body.p.y + (@@HEIGHT/2)), @@WIDTH)

    verts = [CP::Vec2.new(0,@@HEIGHT), CP::Vec2.new(@@WIDTH,@@HEIGHT),
	    			 CP::Vec2.new(@@WIDTH,0), CP::Vec2.new(0,0) ]

    CP::recenter_poly(verts)

    shape = CP::Shape::Poly.new(@body, verts, CP::Vec2.new(0,0))

    #shape = CP::Shape::Circle.new(@body, 35, CP::Vec2.new(0.0,0.0))
    shape.u = 0.0 # friction coefficient
    shape.e = 1.0 # elasticity

    space.add_body(@body)
    space.add_shape(shape)
  end

	def draw
    @image.draw_rot(@body.p.x, @body.p.y, 1, @body.a)
	end
end
end