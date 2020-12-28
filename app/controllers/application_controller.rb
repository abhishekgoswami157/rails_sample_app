class ApplicationController < ActionController::Base
  def hello
    render html: "Helloooo Worlddd!"
  end
end
