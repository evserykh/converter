require File.expand_path('conversion_handler', __dir__)

class App < Sinatra::Base
  error ConversionHandler::InvalidParams do
    [422, env['sinatra.error'].message]
  end

  post '/convert' do
    handler = ConversionHandler.new(params)
    tempfile = handler.run
    send_file tempfile.path, filename: 'converted', type: handler.to if tempfile
    [500, 'Something went wrong']
  end
end
