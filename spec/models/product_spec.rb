require 'spec_helper'

describe Product do
  it { should respond_to(:url) }
  it { should respond_to(:api) }
  it { should respond_to(:current_price) }
  it { should respond_to(:name) }
  it { should respond_to(:thumbnail) }
end
