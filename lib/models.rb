require_relative 'database'

class User < Database::Model
  attr_accessor :name, :email

  def tweets
    Tweet.where(user: self)
  end

  def retweets
    Retweet.where(user: self)
  end
end

class Tweet < Database::Model
  attr_accessor :message, :like_count, :user

  def like_count
    @like_count ||= 0
  end

  def user_id=(user_id)
    self.user = User.find(user_id)
  end

  def retweets
    Retweet.where(tweet: self)
  end
end

class Retweet < Database::Model
  attr_accessor :message, :tweet, :user

  def user_id=(user_id)
    self.user = User.find(user_id)
  end

  def tweet_id=(tweet_id)
    self.tweet = Tweet.find(tweet_id)
  end
end
