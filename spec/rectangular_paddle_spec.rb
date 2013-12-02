require 'spec_helper'
require 'pong/rectangular_paddle'

describe Pong::RectangularPaddle do
	before :each do
		@paddle = Pong::RectangularPaddle.new 10, 20
	end

  it "should initialize with a width and a height" do
    @paddle.width.should eq 10
    @paddle.height.should eq 20
  end

  it 'should be active after calling activate' do
  	@paddle.activate
  	@paddle.active.should be true
  end

  it 'should be inactive after calling deactivate' do
  	@paddle.deactivate
  	@paddle.active.should be false
  end

end
