require 'vector'

module Pong
class Paddle
	attr_accessor :id, :position, :angle, :active

	def initialize(id)
		@id = id
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
	end
end
end