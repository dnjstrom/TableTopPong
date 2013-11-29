require 'vector'

module Pong
module Paddle
	attr_accessor :position, :angle, :active

	def initialize()
		@position = Vector.new
		@angle = 0
		@active = false
	end

	def activate
		@active = true
		self
	end

	def deactivate
		@active = false
		self
	end
end
end