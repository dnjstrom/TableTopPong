#!/usr/bin/ruby
unless $LOAD_PATH.include?(File.expand_path(File.dirname(__FILE__)))
  $LOAD_PATH.unshift(File.expand_path(File.dirname(__FILE__)))
end

require 'pong/game'

# Provides the namespace "Pong" and starts the application when run with
# the command 'ruby pong.rb'.
module Pong
	def self.start
		game = Game.new
		game.start
	end
end

# Only start the game when loaded from command line
if $0 == __FILE__
	Pong::start
end