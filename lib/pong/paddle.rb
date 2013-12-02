require 'vector'

module Pong
module Paddle
	@position = Vector.new
	@angle = 0
	@active = false

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