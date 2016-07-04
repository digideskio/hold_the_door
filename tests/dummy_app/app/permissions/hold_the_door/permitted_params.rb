#
# Describe which params will be permitted
# for this user in this controller's action
#
module HoldTheDoor::PermittedParams
  def permitted_params(controller, options)
    user   = controller.current_account
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
    if user.try(:admin?)
      [
        :a, :b, :c,

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
    {}
  end
end
