set :enviroment, :development
set :root, File.dirname(__FILE__)
set :views, Proc.new{File.join(root,"views")}
set :public, Proc.new{File.join(root,"public")}
set :haml, {:format => :html5, :attr_wrapper => '"'}
enable :logging, :dump_errors, :raise_errors