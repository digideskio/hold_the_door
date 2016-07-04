module HoldTheDoor
  module ViewHelpers
    extend ActiveSupport::Concern

    module ClassMethods
      def hold_the_door!
        if defined?(Devise)
          before_action :"authenticate_#{ Devise.default_scope }!"
        end

        before_action :authorize_action!
      end
    end

    included do
      def current_user_method
        if defined?(Devise)
          method_name = "current_#{ Devise.default_scope }"
          __send__(method_name) if respond_to?(method_name)
        end
      end

      def can?(scope, action, options = {})
        HoldTheDoor.can?(current_user_method, scope, action, options)
      end

      def owner?(obj, options = {})
        HoldTheDoor.owner?(current_user_method, obj, options)
      end

      def owner_can?(obj, scope, action, options = {})
        HoldTheDoor.owner_can?(current_user_method, obj, scope, action)
      end

      def permitted_params(options = {})
        HoldTheDoor.permitted_params(self, options)
      end

      def with_permitted_params(options = {})
        HoldTheDoor.with_permitted_params(self, options)
      end

      def permitted_param?(scope, action = nil, options = {})
        HoldTheDoor.permitted_param?(self, scope, action, options)
      end

      def authorize_owner!(obj, options = {})
        unless owner?(obj, options)
          raise HoldTheDoor::OwnerRequired.new(
            obj: obj,
            options: options
          )
        end
      end

      def authorize_action!(options = {})
        scope  = self.controller_name
        action = self.action_name

        unless can?(scope, action, options)
          raise HoldTheDoor::ActionPermissionRequired.new(
            scope:   scope,
            action:  action,
            options: options
          )
        end
      end
    end
  end
end
