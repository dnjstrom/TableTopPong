require 'tuio-ruby'

module Pong
class Tracker
	def initialize
		@tc = TuioClient.new
		@objects = Hash.new

		@tc.on_object_creation do | to |
			@objects[to.fiducial_id] = TuioObject.new(to.x_pos, to.y_pos)
		 	puts "New TUIO Object #{to.fiducial_id} at x: #{to.x_pos}, y: #{to.y_pos}"
		end

		@tc.on_object_update do | to |
			tuiObject = @objects[to.fiducial_id]
			tuiObject.updatePosition(to.x_pos, to.y_pos)
		  	puts "Updated TUIO Object #{to.fiducial_id} at x: #{to.x_pos}, y: #{to.y_pos}"
		end

		@tc.on_object_removal do | to |
			puts "Removed TUIO Object #{to.fiducial_id}"
		end

		@tc.start
		sleep
	end

	def getPosition(id)
		@objects[id]
	end

	class TuioObject
		attr_accessor :x, :y

		def initialize(x, y)
			updatePosition(x, y)
		end

		def updatePosition(x, y)
			@x = x
			@y = y
		end
	end
end
end