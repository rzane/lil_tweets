require 'graphql'

module Types
  class UserType < GraphQL::Schema::Object
    field :id, ID, null: false
    field :name, String, null: true
    field :email, String, null: true
    field :tweets, ['::Types::TweetType'], null: false
    field :retweets, ['::Types::RetweetType'], null: false
  end

  class UserInput < GraphQL::Schema::InputObject
    argument :name, String, required: false
    argument :email, String, required: false
  end

  class TweetType < GraphQL::Schema::Object
    field :id, ID, null: false
    field :message, String, null: false
    field :like_count, Integer, null: false
    field :user, UserType, null: false
    field :retweets, ['::Types::RetweetType'], null: false
  end

  class TweetInput < GraphQL::Schema::InputObject
    argument :message, String, required: true
    argument :user_id, ID, required: true
  end

  class RetweetType < GraphQL::Schema::Object
    field :id, ID, null: false
    field :tweet, TweetType, null: false
    field :user, UserType, null: false
    field :message, String, null: true
  end

  class RetweetInput < GraphQL::Schema::InputObject
    argument :tweet_id, ID, required: true
    argument :user_id, ID, required: true
    argument :message, String, required: false
  end
end
