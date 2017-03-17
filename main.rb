# require 'pry'
require 'sinatra'
# require 'sinatra/reloader'
require 'pg'
require_relative 'database_config'
require_relative 'models/sneaker'
require_relative 'models/user'
require_relative 'models/comment'

enable :sessions
helpers do

  def current_user
    User.find_by(id: session[:user_id])
  end

  def logged_in? #should return a boolean
    !!current_user #can be written as current_user != nil without if else
  end

end

after do
  ActiveRecord::Base.connection.close
end

get '/' do
  redirect '/session/new' unless logged_in?
  @sneakers = Sneaker.all
  # sql = "SELECT * FROM sneakers;"
  # @sneakers = run_sql(sql)
  erb :index
end

get '/sneakers/new' do
  erb :new
end

get '/sneakers/search' do
  if params[:brand] == ""
    erb :search
  else
    @sneakers = Sneaker.where("name ILIKE '%#{params[:brand]}%'")
    if @sneakers.empty?
      erb :unknown
    else
      erb :list
    end
  end
end

get '/search' do
  erb :search
end

post '/sneakers' do
  redirect '/session/new' unless logged_in?
  sneaker = Sneaker.new
  sneaker.name = params[:name]
  sneaker.img_url = params[:img_url]
  sneaker.size = params[:size]
  sneaker.price = params[:price]
  sneaker.save

  if sneaker.save
    redirect '/'
  else
    erb :new
  end
end

get '/sneakers/signup' do
  erb :signup
end

post '/signup' do
  user = User.new
  user.name = params[:name]
  user.email = params[:email]
  user.password = params[:password]
  user.save

  if user.save
    erb :signup_success
    # redirect '/'
  else
    erb :signup
  end
end

get '/sneakers/:id' do
  # redirect '/session/new' unless logged_in?
  @sneaker = Sneaker.find(params[:id])
  @comments = @sneaker.comments
  erb :show
end

delete '/sneakers/:id' do
  sneaker = Sneaker.find(params[:id])
  sneaker.destroy
  redirect '/'
end

get '/sneakers/:id/edit' do
  redirect '/session/new' unless logged_in? #or if !logged_in
  @sneaker = Sneaker.find(params[:id])
  erb :edit
end

put '/sneakers/:id' do
  redirect '/session/new' unless logged_in? #or if !logged_in
  sneaker = Sneaker.find(params[:id])
  sneaker.name = params[:name]
  sneaker.img_url = params[:img_url]
  sneaker.size = params[:size]
  sneaker.price = params[:price]
  sneaker.save
  redirect '/'
end

post '/comments' do
  redirect '/session/new' unless logged_in?
  comment = Comment.new
  comment.body = params[:body]
  comment.sneaker_id = params[:sneaker_id]
  comment.user_id = session[:user_id]
  # user.email = session[:email]
  # comment.save
   if comment.save
    redirect "/sneakers/#{ params[:sneaker_id] }"
  else
     erb :show
   end
end

put '/comments' do
  @comment = Comment.find(params[:id])
  comment.body = params[:body]
  comment.sneaker_id = params[:sneaker_id]
  comment.user.email = params[:email]
end

get '/session/new' do
    erb :login
end

post '/session' do
  user = User.find_by(email: params[:email])
  if user && user.authenticate(params[:password])
    # you are good to go and create a session for you
    session[:user_id] = user.id #made up id name
    redirect '/'
  else
    erb :login
    # i have to kick you out...who are you?
  end
end

# logout
delete'/session' do
session[:user_id] = nil
redirect '/session/new'
end
