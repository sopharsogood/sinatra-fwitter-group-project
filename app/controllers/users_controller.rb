class UsersController < ApplicationController

    get '/signup' do
        if Helper.logged_in?(session)
            flash[:message] = "You're already logged in!"
            redirect '/tweets'
        end
        erb :'/users/create_user'
    end

    get '/login' do
        if Helper.logged_in?(session)
            flash[:message] = "You're already logged in!"
            redirect '/tweets'
        end
        erb :'/users/login'
    end

    get '/logout' do
        if !Helper.logged_in?(session)
            flash[:message] = "You're already logged out!"
            redirect '/login'
        end
        erb :'/users/logout'
    end

    post '/logout' do
        session.clear
        redirect '/login'
    end

    post '/login' do
        user = User.find_by(username: params[:username])
        if user && user.authenticate(params[:password])
            session[:user_id] = user.id
            session[:message] = "Login successful! Welcome, #{Helper.current_user(session).username}!"
            redirect '/tweets'
        else
            flash[:message] = "Incorrect username or password. Login failed."
            redirect '/login'
        end
    end

    post '/signup' do
        user = User.new(username: params[:username], password: params[:password], email: params[:email])
        if user.save
            session[:user_id] = user.id
            session[:message] = "Signup successful! Welcome, #{Helper.current_user(session).username}!"
            redirect '/tweets'
        else
            flash[:message] = "An error occurred. Signup failed."
            redirect '/signup'
        end
    end

    get '/users/:slug' do
        Helper.logged_in_only(session)
        @user = User.find_by_slug(params[:slug])
        erb :'/users/show'
    end

end
