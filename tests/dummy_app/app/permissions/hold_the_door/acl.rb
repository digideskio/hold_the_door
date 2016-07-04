#
# Describe your own way how to check Access Rule
# After that you can use:
#
# For Model
#
# - @user.can?(:pages, :edit)
# - @user.can?(@page, :edit) => @user.owner_can?(@page, :pages, :edit)
#
# - @user.owner_can?(@page, :edit)
# - @user.owner_can?(@page, :pages, :edit)
# - @user.owner_can?(@page, :twitter, :xxl_button)
#
# For Controller/View
#
# - can?(:pages, :edit)
# - can?(@page, :edit) => @user.owner_can?(@page, :pages, :edit)
#
# - owner_can?(@page, :edit)
# - owner_can?(@page, :pages, :edit)
# - owner_can?(@page, :twitter, :xxl_button)
#

# There is a simple but enough powerful example
# How you can organize your ACL checking process
# I offer to you use this way, but you can create something more complex
#
module HoldTheDoor::ACL
  def can?(user, scope, action, options)
    return true
    # Admin can do everything
    return true if user.try(:admin?)

    role_name = user.try(:role) || 'guest'

    # Get ACL (Acceess Control List) for this Role
    acl = case role_name
      when 'user'
        user_acl
      else
        guest_acl
    end

    # Does user have this permission or not?
    # It returns `true` if testable rule is exist
    acl.first.try(:[], scope).try(:include?, action)
  end

  private

  # Access Control List
  #
  # Definition of Access Rules for specific user's role
  # Formed according to Rails naming of Controller/Action
  # It can describes access rules to controller's actions
  # And any arbitrary access rules
  #
  def user_acl
    [
      pages: [
        :index,
        :show,
        :edit
      ],
      accounts: [
        :index,
        :show
      ]
    ]
  end

  # No special access rules for Guests
  def guest_acl
    []
  end
end
