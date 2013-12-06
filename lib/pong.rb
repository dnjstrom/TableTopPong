#!/usr/bin/ruby
unless $LOAD_PATH.include?(File.expand_path(File.dirname(__FILE__)))
  $LOAD_PATH.unshift(File.expand_path(File.dirname(__FILE__)))
end

require 'pong/game'

# Provides the namespace "Pong" and starts the application when run with
# the command 'ruby pong.rb'.
module Pong
	def self.start
		# default options
		options = {}

		option = nil
		state = -1

		ARGV.each do|arg|
			option = arg unless option

			case option
			when '-f'
				options[:fullscreen] = true
				option = nil
			when '-w'
				if state == 0
					options[:width] = arg.to_i
					option = nil
				else
					state = 1
				end
			when '-h'
				if state == 0
					options[:height] = arg.to_i
					option = nil
				else
					state = 1
				end
			end

			state -= 1
		end		

		game = Game.new options
		game.start
	end
end

# Only start the game when loaded from command line
if $0 == __FILE__
	Pong::start
end