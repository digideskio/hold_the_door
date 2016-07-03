#
# Describe which params will be permitted
# for this user in this controller's action
#
module HoldTheDoor::PermittedParams
  def permitted_params(controller, options)
    user   = options[:user]
    params = controller.params
    controller_name = controller.controller_name

    case controller_name
      when 'pages'
        pages_params(user, params)
      when 'accounts'
        accounts_params(user, params)
    end
  end

  private

  def pages_params(user, params)
    if user.admin?
      params.require(:page)
        .permit(
          :title,
          :content,
          :state,

          :account_id,
          :moderation_comment,
        )
    else
      params.require(:page)
        .permit(
          :title,
          :content,
          :state
        )
    end
  end

  def accounts_params(user, params)
    {}
  end
end
