require 'rspec'
require './rate_limiter.rb'

RSpec.describe RateLimiter do
  let(:user_name)    { "amber@stripe.com" }
  let(:rate_limiter) { RateLimiter.new(user_name) }

  before(:each) do
    RateLimiter.reset!
  end

  context "login" do
    it "increments a counter" do
      expect {
        rate_limiter.check!
      }.to change { rate_limiter.count }.by(1)
    end

    context "with a spam bot" do
      before(:each) do
        19.times do
          rate_limiter.check!
        end
      end

      it "explodes" do
        expect(rate_limiter.count).to eq(19)
        expect {
          rate_limiter.check!
        }.to raise_error(RateLimiter::RateLimitExceeded)
      end
    end
  end
end
