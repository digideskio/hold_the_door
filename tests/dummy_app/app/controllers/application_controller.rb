class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  hold_the_door!
end
