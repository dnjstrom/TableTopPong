unless $LOAD_PATH.include?(File.expand_path(File.dirname(__FILE__)))
  $LOAD_PATH.unshift(File.expand_path(File.dirname(__FILE__)))
end

require 'pong/game'

# Provides the namespace "Pong" and starts the application when run with
# the command 'ruby pong.rb'.
module Pong
	def self.start
		game = Game.new
	end
end

Pong::start