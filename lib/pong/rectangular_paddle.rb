require 'pong/paddle'

module Pong
class RectangularPaddle < Paddle
	include Paddle

	attr_accessor :width, :height

	def initialize(width, height = width)
		@width = width
		@height = height
		super
	end
end
end