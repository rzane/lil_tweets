require 'graphql'
require_relative 'models'
require_relative 'types'

module Types
  class Query < GraphQL::Schema::Object
    field :users, [UserType], null: false
    field :user, UserType, null: false do
      argument :id, ID, required: true
    end

    field :tweets, [TweetType], null: false
    field :tweet, TweetType, null: false do
      argument :id, ID, required: true
    end

    field :retweets, [RetweetType], null: false
    field :retweet, RetweetType, null: false do
      argument :id, ID, required: true
    end

    def users
      User.all
    end

    def user
      User.find(id)
    end

    def tweets
      Tweet.all
    end

    def tweet(id:)
      Tweet.find(id)
    end

    def retweets
      Retweet.all
    end

    def retweet(id:)
      Retweet.find(id)
    end
  end

  class Mutation < GraphQL::Schema::Object
    field :register, UserType, null: false do
      argument :data, UserInput, required: true
    end

    field :create_tweet, TweetType, null: false do
      argument :data, TweetInput, required: true
    end

    field :like_tweet, Integer, null: false do
      argument :id, ID, required: true
    end

    field :create_retweet, RetweetType, null: false do
      argument :data, RetweetInput, required: true
    end

    def register(data:)
      User.create(data)
    end

    def create_tweet(data:)
      Tweet.create(data)
    end

    def like_tweet(id:)
      tweet = Tweet.find(id)
      tweet.like_count += 1
      tweet.save
      tweet.like_count
    end

    def create_retweet(data:)
      Retweet.create(data)
    end
  end
end

class Schema < GraphQL::Schema
  query Types::Query
  mutation Types::Mutation
end
