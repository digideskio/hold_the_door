class WelcomeController < ApplicationController
  skip_before_action :authenticate_account!, only: [:index, :autologin]

  def index;   end
  def profile; end

  def autologin
    account = Account.find_by_email params[:email]
    sign_in account if account
    redirect_to request.referrer || root_path
  end
end
