class PagesController < ApplicationController
  before_action :set_page, only: [:show, :edit, :update, :destroy]
  before_action ->{ authorize_owner!(@page) }, only: [:edit, :update, :destroy]

  def index
    @pages = Page.with_state(:published).all
  end

  def show; end

  # Login && role

  def new
    @page = Page.new
  end

  def create
    @page = current_user.pages.new with_permitted_params

    if @page.save
      redirect_to @page, notice: 'Page was successfully created.'
    else
      render action: 'new'
    end
  end

  def my
    @pages = current_account.pages
  end

  # login && role && ownership

  def edit; end

  def update
    if @page.update with_permitted_params
      redirect_to @page, notice: 'Page was successfully updated.'
    else
      render action: :edit
    end
  end

  def destroy
    @page.destroy
    redirect_to pages_url
  end

  # Admin or Pages Moderator Role require

  def manage
    @pages = Page.all
  end

  private

  def set_page
    @page = Page.find params[:id]
  end
end
