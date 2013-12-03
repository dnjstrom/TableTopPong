require 'spec_helper'
require 'pong/game'

describe Pong::Game do
	before :each do
		@game = Pong::Game.new
	end

	# Use send to access private method
	
  #it "should convert between ranges correctly" do
  #	value = @game.send :convert_range, 50, 0, 100, 0, 1000
  #	value.should eq 500
  #end

  #it "should convert between ranges correctly" do
  #	value = @game.send :convert_range, 0, -100, 100, 0, 1000
  #	value.should eq 500
  #end

  #it "should convert between ranges correctly" do
  #	value = @game.send :convert_range, 0, 100, -100, 0, 1000
  #	value.should eq 500
  #end

  it "should convert between ranges correctly" do
  	value = @game.send :convert_range, 550, 0, 100, 1000, 0
  	value.should eq 500
  end
end