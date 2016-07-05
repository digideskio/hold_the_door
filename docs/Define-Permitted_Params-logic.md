### Permitted Params Definition

```ruby
module HoldTheDoor::PermittedParams
  def permitted_params(controller, options)
    user = controller.current_account
    controller_name = controller.controller_name

    #
    # Select Array of Permitted Params for this Controller
    #
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
    #
    # Select Array of Permitted Params for this user's Role
    #
    if user.try(:admin?)
      [
        page: [
          :title,
          :content,
          :state,

          :account_id,
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
