require 'rspec'
require './rate_limiter.rb'

RSpec.describe RateLimiter do
  let(:username)     { "amber@stripe.com" }
  let(:rate_limiter) { RateLimiter.new(username) }

  context "login" do
    it "increments a counter" do
      expect {
        rate_limiter.check!
      }.to change { rate_limiter.count }.by(1)
    end

    context "with a spam bot" do
      before(:each) do
        rate_limiter.count = 19
      end

      it "explodes" do
        expect {
          rate_limiter.check!
        }.to raise_error(RateLimiter::RateLimitExceeded)
      end
    end
  end
end
