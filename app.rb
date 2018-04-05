require 'sinatra'
require 'sinatra/activerecord'
require './models'

set :database, "sqlite3:second_app.sqlite3"


get '/' do

    erb :home
end 

get '/posts' do
    @posts = Post.all
    erb :posts
end

get '/users' do
    @users = User.all
    erb :users
end 