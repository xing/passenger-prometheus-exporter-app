require 'sinatra/base'

class DummyApp < Sinatra::Base
  get '/' do
    content_type 'text/plain'
    return "OK"
  end
end
