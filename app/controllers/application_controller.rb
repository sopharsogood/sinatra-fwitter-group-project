require './config/environment'
require 'rack-flash'

class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, '688995e6267ec6e5cf1cf02dcbe834ef8d8d6a4c74985fb108362c423fa4784923e49eb378fdb1d9f86af28f1e94452f4f5716e8e597ad6b5b9addab3c67b465'
    use Rack::Flash
  end

  get '/' do
    erb :index
  end


  class Helper
    def self.current_user(session)
      User.find_by(id: session[:user_id])
    end

    def self.logged_in?(session)
      !!session[:user_id]
    end

    def self.logged_in_only(session)
      if !Helper.logged_in?(session)
        flash[:message] = "You must be logged in to view tweets!"
        redirect '/'
      end
    end
  end
  
  
end
