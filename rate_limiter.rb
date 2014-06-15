class RateLimiter
  MAX_REQUESTS = 20

  class RateLimitExceeded < StandardError; end

  attr_reader :username
  attr_accessor :count

  def initialize(username)
    @username = username
    @count = 0
  end

  def check!
    increment
    if count >= MAX_REQUESTS
      raise RateLimitExceeded.new("#{username} has exceeded the maximum number of requests")
    end
  end

  def increment
    self.count += 1
  end
end
