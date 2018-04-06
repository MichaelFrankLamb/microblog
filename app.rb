require 'sinatra'
require 'sinatra/activerecord'
require './models'
require 'sinatra/flash'
enable :sessions

set :database, "sqlite3:second_app.sqlite3"

def current_user
    if session[:user_id]
        @current_user = User.find(session[:user_id])
    end
end

get '/' do

    erb :home
end 

get '/profile' do
    current_user
    @posts = @current_user.posts
    erb :profile
end

get '/profile/:id' do
    @user = User.find(params[:id])
    @posts = @user.posts
    erb :profile
end

get '/posts' do
    @posts = Post.all
    erb :posts
end

get '/users' do
    @users = User.all
    erb :users
end 

post '/users/new' do
    puts"kkkkkkkkkkk"
    puts params.inspect
    #{"post"=>{"fname"=>"Han", "lname"=>"Solo", "age"=>"54"}, "captures"=>[]} in irb
    puts "aaaaaaaa"
    User.create(params[:post])
    #@user = User.where(id: params[:id])
    #session[:user_id] = @user.id
    redirect "/"
end

post '/sign-in' do
    @user = User.where(fname: params[:fname]).first
    if @user.password == params[:password]
        session[:user_id] = @user.id
        #flash[:notice] = "success!"
        redirect "/profile/#{@user.id}"
    else
        #flash[:notice] = "Fail"
        redirect '/'
    end
end

post '/sign-out' do
    session[:user_id] = nil
    redirect '/'
end

post '/newpost' do
    current_user
    Post.create(params[:post])
    redirect "/profile/#{@current_user.id}"
end