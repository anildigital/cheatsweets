require 'app'

set :env,       :production
set :port,      4567
disable :run, :reload

run Sinatra.application
