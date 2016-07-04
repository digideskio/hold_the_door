module HoldTheDoor
  module Base
    extend ActiveSupport::Concern

    class_methods do
      def storage
        HoldTheDoor::Storage.instance
      end

      def owner?(user, obj, options = {})
        storage.owner?(user, obj, options)
      end

      def can?(user, scope, action, options = {})
        storage.can?(user, scope, action, options)
      end

      def owner_can?(user, obj, scope, action = nil)
        scope, action = storage.get_scope_action(obj, scope, action)
        owner?(user, obj) && can?(user, scope, action)
      end

      def permitted_params(controller, options)
        storage.permitted_params(controller, options)
      end

      alias_method :authorize_owner_and_action!, :owner_can?
      alias_method :authorize_owner!,  :owner?
      alias_method :authorize_action!, :can?
    end
  end

  include ::HoldTheDoor::Base

  module StorageBase
    def get_scope_action(obj, scope, action)
      if action.blank?
        action = scope
        scope  = scope_for(obj)
      end

      [scope, action]
    end

    def scope_for(obj)
      :pages
    end
  end
end
