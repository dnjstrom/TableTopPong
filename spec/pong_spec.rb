require 'pong'
require 'vector'

describe Pong do
  it "is not a bartender" do
  	expect { Pong.mix(:mojito) }.to raise_error
  end

  it "loads the vector library" do
  	v = Vector.new(3, 4)
  	v.length.should eq 5
  end
end