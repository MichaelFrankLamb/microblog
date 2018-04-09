require 'sinatra'
require 'sinatra/activerecord'
require './models'
require 'sinatra/flash'
enable :sessions

set :database, "sqlite3:second_app.sqlite3"
set :method_override, true

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

# Edit user profile
get '/profile/:id/edit' do
    @user = User.find(params[:id])
    erb :editprofile
end

# Update user profile
put '/profile/:id' do
    @user = User.find(params[:id])  
    @user.update(params[:post])  
    redirect "/profile"
end

# Delete user profile
delete '/profile/:id' do
    @posts = Post.all
    @user = User.find(params[:id])
    @posts.each do |post|
         if post.user_id == @user.id
            post.update( :user_id => 3)
         else
         end
    end
    @user.destroy
    session[:user_id] = nil
    redirect '/'
end


# Edit post
get '/posts/:id/edit' do   
	@post = Post.find(params[:id])
	erb :edit
end

# Update post
put '/posts/:id' do
    @post = Post.find(params[:id])
    @post.update(params[:post])
    redirect "/profile"
end

# delete post
delete '/posts/:id' do  
	@post = Post.find(params[:id])
	@post.destroy
	redirect "/profile"
end


get '/posts' do
    @users = User.all
    @posts = Post.all
    erb :posts
end

get '/users' do
    @users = User.all
    erb :users
end 

post '/users/new' do
    puts params.inspect
    User.create(params[:post])
    session[:user_id] = User.last.id
    redirect "/profile"
end

post '/sign-in' do
    @user = User.where(fname: params[:fname]).first
    if @user.password == params[:password]
        session[:user_id] = @user.id
        #flash[:notice] = "success!"
        redirect "/profile"
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
    redirect "/profile"
end





# put '/profile/:id' do
#     @user = User.find(params[:id])  ### Getting error after updating profile info pointing to this line
#     @user.update(params[:post])  
#     redirect "/profile"
# end