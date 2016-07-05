### ACL Definition

```ruby
module HoldTheDoor::ACL
  def can?(user, scope, action, options)
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

    # Does this user have this permission or not?
    acl.first.try(:[], scope).try(:include?, action)
  end

  private

  # ==> Access Control List <==
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

  # No special Access rules for Guests
  def guest_acl
    []
  end
end
```
