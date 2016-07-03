class Account < ApplicationRecord
  include HoldTheDoor::ModelHelpers

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :pages

  def role
    id == 1 ? 'admin' : 'user'
  end

  def admin?
    role == 'admin'
  end
end
