require 'rack'
require 'json'
require_relative 'lib/schema'

class GraphQLServer
  def initialize(schema:, context: {})
    @schema = schema
    @context = context
  end

  def call(env)
    request = Rack::Request.new(env)
    payload = if request.get?
      request.params
    else
      JSON.parse(request.body.read)
    end

    result = @schema.execute(
      payload['query'],
      variables: payload['variables'],
      operation_name: payload['operationName'],
      context: @context
    )

    respond(200, result.to_json)
  rescue => error
    warn(error.message)
    warn(error.backtrace.join("\n"))

    body = {
      data: {},
      error: { message: error.message, backtrace: error.backtrace }
    }

    respond(500, body.to_json)
  end

  private def respond(status, body)
    headers = {}
    headers['Content-Type'] = 'application/json'
    headers['Content-Length'] = body.bytesize.to_s
    [status, headers, [body]]
  end
end

use Rack::Static, urls: {'/' => 'index.html'}, root: 'public'
run GraphQLServer.new(schema: Schema)
