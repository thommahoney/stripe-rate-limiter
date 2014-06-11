require 'pry'

class RateLimiter
  MAX_REQUESTS = 20

  class RateLimitExceeded < StandardError
  end

  def self.counts
    @counts ||= Hash.new(0)
  end

  def self.maximum
    MAX_REQUESTS
  end

  def self.reset!
    @counts = nil
  end

  attr_reader :user_name

  def initialize(user_name)
    @user_name = user_name
  end

  def check!
    increment
    if self.count >= self.class.maximum
      raise RateLimitExceeded.new("#{user_name} has exceeded the maximum number of requests")
    end
  end

  def increment
    self.class.counts[user_name] += 1
  end

  def count
    self.class.counts[user_name]
  end
end
