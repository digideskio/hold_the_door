module HoldTheDoor
  module ModelHelpers
    extend ActiveSupport::Concern

    included do
      # ACL

      def can?(scope, action)
        HoldTheDoor.can?(self, scope, action)
      end

      # OWNERSHIP

      def owner?(obj)
        HoldTheDoor.owner?(self, obj)
      end

      # OWNERSHIP & ACL

      def owner_can?(obj, scope, action = nil)
        HoldTheDoor.owner_can?(self, obj, scope, action)
      end

      # ALIASES

      alias_method :authorize_action!,       :can?
      alias_method :authorize_owner!,        :owner?
      alias_method :authorize_owner_action!, :owner_can?
    end
  end
end
