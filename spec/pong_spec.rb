require 'pong'

describe Pong do
  it "is not a bartender" do
  	expect { Pong.mix(:mojito) }.to raise_error
  end
end