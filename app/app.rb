# frozen_string_literal: true

class App < Sinatra::Base
  get '/' do
    content_type 'text/html'
    'This is event maker service!'
  end

  use EventMaker

  def route_missing
    halt 404
  end
end
