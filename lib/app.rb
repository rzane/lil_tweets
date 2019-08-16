require 'sinatra/base'
require 'rack/contrib'

class App < Sinatra::Base
  use Rack::PostBodyContentTypeParser

  post '/graphql' do
    result = ConferenceAppSchema.execute(
      params[:query],
      variables: params[:variables],
      context: { current_user: nil },
    )
    json result
  end
end
