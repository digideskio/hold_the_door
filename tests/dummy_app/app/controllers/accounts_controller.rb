class AccountsController < ApplicationController
  before_action :find_account

  def edit; end

  def update
    @account.update_attributes account_params
    flash[:notice] = 'Account was successfully updated.'
    redirect_to edit_account_path @account
  end

  private

  def find_account
    @account = Account.find params[:id]
  end

  def account_params
    params.require(:account).permit(:name, :email)
  end
end
