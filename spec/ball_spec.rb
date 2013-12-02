require 'spec_helper'
require 'pong/rectangular_paddle'

describe Pong::Ball do
	before :each do
		@ball = Pong::Ball.new 0, 0, 20, 10, 10
	end

  it "should move according to its velocity" do
  	5.times { @ball.move }
  	@ball.position.x.should be_within(0.0000001).of 50 
  	@ball.position.y.should be_within(0.0000001).of 50
  end
end