require 'pong/paddle'

module Pong
class RectangularPaddle
	include Paddle

	attr_accessor :width, :height, :active

	def initialize(width, height)
		height = width if height == nil

		@width = width
		@height = height
	end
end
end