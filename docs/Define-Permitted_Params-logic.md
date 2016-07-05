### Permitted Params Definition

```ruby
module HoldTheDoor::PermittedParams
  def permitted_params(controller, options)
    user   = controller.current_user
    controller_name = controller.controller_name

    case controller_name
      when 'pages'
        pages_params(user)
      when 'accounts'
        accounts_params(user)
      else
        []
    end
  end

  private

  def pages_params(user)
    if user.admin?
      # Admin can change page's user
      # and leave a moderation comment
      [
        page: [
          :title,
          :content,
          :state,

          :user_id,
          :moderation_comment,
        ]
      ]
    else
      [
        page: [
          :title,
          :content,
          :state
        ]
      ]
    end
  end

  def accounts_params(user)
    []
  end
end
```
