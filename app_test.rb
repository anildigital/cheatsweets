require 'rubygems'
require 'sinatra'
require 'sinatra/test/spec'
require 'app'

describe :app do

  it "should show index page" do
    get_it '/'
    should.be.ok
  end
  
  it "should show page" do
    get_it '/query/emacs'
    should.be.ok
  end
  
end

