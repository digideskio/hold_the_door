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

    # Does user have this permission or not?
    # It returns `true` if testable rule is exist
    acl_check(acl, scope, action)
  end

  private

  def acl_check(acl, scope, action)
    acl.first.try(:[], scope).try(:include?, action) || false
  end

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

  def guest_acl
    []
  end
end
```
