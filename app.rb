require 'rubygems'
require 'sinatra'

$cheats_list = (`cheat sheets`).split("\n")


get "/" do

  cheats_size = $cheats_list.size
  current_cheat = $cheats_list[rand(cheats_size)]

  @cookie = request.cookies["last_cheat"]

  if current_cheat == @cookie
    redirect "/"
  end

  @cheats =  (`cheat #{current_cheat}`).split("\n")

  # Reset the cookie
  set_cookie("last_cheat", current_cheat)
  erb :index

end


get "/query/:cheat" do

  current_cheat = params[:cheat]
  @cookie = request.cookies["last_cheat"]

  @cheats =  (`cheat #{current_cheat}`).split("\n")

  # Reset the cookie
  set_cookie("last_cheat", current_cheat)
  erb :index

end


#Exception handing for production environment
configure :production do

  not_found do
    'This is nowhere to be found'
  end

  error do
    'Sorry there was a nasty error - ' + request.env['sinatra.error'].name
  end

end
