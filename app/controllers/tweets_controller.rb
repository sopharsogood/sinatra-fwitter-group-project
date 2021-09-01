class TweetsController < ApplicationController

    get '/tweets' do
        redirect '/login' if !Helper.logged_in?(session)
        @tweets = Tweet.all
        if session[:message]
            flash[:message] = session[:message]
            session[:message] = nil
        end
        erb :'/tweets/tweets'
    end

    get '/tweets/new' do
        redirect '/login' if !Helper.logged_in?(session)
        erb :'/tweets/new'
    end

    get '/tweets/:id' do
        redirect '/login' if !Helper.logged_in?(session)
        @tweet = Tweet.find_by(id: params[:id])
        @original_poster = true if Helper.current_user(session) == @tweet.user
        erb :'/tweets/show_tweet'
    end

    get '/tweets/:id/edit' do
        redirect '/login' if !Helper.logged_in?(session)
        @tweet = Tweet.find_by(id: params[:id])
        if Helper.current_user(session) == @tweet.user
            erb :'/tweets/edit_tweet'
        else
            flash[:message] = "Only the original poster can edit a tweet."
            redirect '/tweets/' + params[:id]
        end
    end

    post '/tweets/new' do
        redirect '/login' if !Helper.logged_in?(session)
        if params[:content] == ""
            flash[:message] = "Can't make a tweet blank!"
            redirect '/tweets/new'
        end
        tweet = Tweet.create(user: Helper.current_user(session), content: params[:content])
        flash[:message] = "Congratulations! Tweet posted!"
        redirect '/tweets/' + tweet.id.to_s
    end

    delete '/tweets/:id' do
        redirect '/login' if !Helper.logged_in?(session)
        tweet = Tweet.find_by(id: params[:id])
        if Helper.current_user(session) == tweet.user
            tweet.destroy
            flash[:message] = "Tweet deleted!"
            redirect '/tweets'
        else
            flash[:message] = "Only the original poster can delete a tweet."
            redirect '/tweets/' + params[:id]
        end
    end

    patch '/tweets/:id' do
        redirect '/login' if !Helper.logged_in?(session)
        if params[:content] == ""
            flash[:message] = "Can't make a tweet blank!"
            redirect '/tweets/' + params[:id] + '/edit'
        end
        tweet = Tweet.find_by(id: params[:id])
        if Helper.current_user(session) == tweet.user
            tweet.update(content: params[:content])
            flash[:message] = "Tweet updated!"
        else
            flash[:message] = "Only the original poster can delete a tweet."
        end
        redirect '/tweets/' + params[:id]
    end
end
