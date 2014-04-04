require 'spec_helper'

describe Tracker do
  it { should respond_to(:original_price) }
  it { should respond_to(:alert_price) }
  it { should respond_to(:name) }
  it { should respond_to(:product_id) }
  it { should respond_to(:user_id) }
end
