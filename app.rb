require 'rubygems'
require 'sinatra'
require 'builder'
require 'json'

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

  current_cheat = params[:cheat].split(".")[0]
  @cookie = request.cookies["last_cheat"]

  if (current_cheat == @cookie) and (current_cheat.nil? or current_cheat == "")
    redirect "/"
  end

  @cheats =  (`cheat #{current_cheat}`).split("\n")

  # Reset the cookie
  set_cookie("last_cheat", current_cheat)
  if params[:cheat].match(/(.xml)$/)
    @cheat_name, @cheat_info = get_cheat_data(@cheats)
    builder :index
  elsif params[:cheat].match(/(.json)$/)
    content_type 'application/json', :charset => 'utf-8'
    @cheat_name, @cheat_info = get_cheat_data(@cheats)
    response_json = {:cheat_name => @cheat_name, :cheat_info => @cheat_info}
    response_json.to_json
  else
    erb :index
  end

end


def get_cheat_data(cheats)
  cheat_name = @cheats[0].gsub(":", "")
  cheats.shift
  cheat_info = cheats.join("<br />")
  return cheat_name, cheat_info
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
