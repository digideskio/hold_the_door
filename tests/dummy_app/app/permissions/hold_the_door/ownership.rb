#
# Describe your own way how to define owner of Object
#
module HoldTheDoor::Ownership
  def owner?(user, obj, options)
    # Admin is owner of everything
    return true if user.admin?

    # Simple ownership check
    user.id == obj.account_id
  end
end
