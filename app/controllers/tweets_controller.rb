class TweetsController < ApplicationController

    get '/tweets' do
        Helper.logged_in_only(session)
        @tweets = Tweet.all
        if session[:message]
            flash[:message] = session[:message]
            session[:message] = nil
        end
        erb :'/tweets/tweets'
    end

    get '/tweets/new' do
        Helper.logged_in_only(session)
        erb :'/tweets/new'
    end

    get '/tweets/:id' do
        Helper.logged_in_only(session)
        @tweet = Tweet.find_by(id: params[:id])
        @original_poster = true if Helper.current_user(session) == @tweet.user
        erb :'/tweets/show_tweet'
    end

    get '/tweets/:id/edit' do
        Helper.logged_in_only(session)
        @tweet = Tweet.find_by(id: params[:id])
        if Helper.current_user(session) == @tweet.user
            erb :'/tweets/edit_tweet'
        else
            flash[:message] = "Only the original poster can edit a tweet."
            redirect '/tweets/' + params[:id]
        end
    end

    post '/tweets/new' do
        Helper.logged_in_only(session)
        tweet = Tweet.create(user: Helper.current_user(session), content: params[:content])
        flash[:message] = "Congratulations! Tweet posted!"
        redirect '/tweets/' + tweet.id.to_s
    end

    delete '/tweets/:id' do
        Helper.logged_in_only(session)
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
        Helper.logged_in_only(session)
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
