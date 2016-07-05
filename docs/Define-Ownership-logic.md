### Ownership Definition

```ruby
module HoldTheDoor::Ownership
  def owner?(user, obj, options)
    # Admin is owner of everything
    return true if user.admin?

    # Simple ownership check
    user.id == obj.user_id
  end
end
```
