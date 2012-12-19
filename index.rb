require 'sinatra'
require 'active_record'  
require 'activerecord-mysql2-adapter'
require 'haml'
require './config.rb'
require './db.rb'
require 'sinatra/simple-authentication'
require 'sinatra/base'
require 'debugger'

class Workingtime < ActiveRecord::Base
	belongs_to :Ar_users
end
class Ar_users < ActiveRecord::Base
	has_many :Workingtime
end 
class TimeController <Sinatra::Base
	register Sinatra::SimpleAuthentication
	get '/admin' do
		@users = Ar_users.all;
		wtimes = Workingtime.all;
		;debugger;
		maxtime = Workingtime.maximum(:endtime)
		mintime = Workingtime.minimum(:starttime)
		@time=0
		wtimes.each do |wts|
			t = wts.endtime-wts.starttime;
			t = t.round.abs
			@time += t
		end
		@time = @time/3600
		haml :admin
	end

	get '/' do
		login_required
		current_user
		if logged_in?
			cnt = Workingtime.where(:ar_users_id => current_user, :active => 1).count();
			if cnt > 0
				@started = 1
			else
				@started = -1
			end
			haml :index
		else
			redirect '/login'
		end
	end
	get '/start' do
		if logged_in?
			usr = Ar_users.where(:id => current_user).first
			wtime = Workingtime.new(:starttime => Time.now, :ar_users_id => usr.id, :active =>1)
			wtime.save
			@started = 1;
			# @workingtimes = Workingtime.order("idtime DESC").limit(4) 
			haml :index
		else
			redirect '/login'
		end
	end
	get '/end' do
		if logged_in?
			wtime = Workingtime.where(:ar_users_id => current_user, :active => 1).first
			wtime.endtime = Time.now
			wtime.active =	0;
			wtime.comments = params[:comments]
			wtime.save			
			redirect '/'
		else
			redirect '/login'
		end
	end
	run! if app_file == $0
end