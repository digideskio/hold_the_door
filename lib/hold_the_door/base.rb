module HoldTheDoor
  module Base
    extend ActiveSupport::Concern

    class_methods do
      def storage
        HoldTheDoor::Storage.instance
      end

      def owner?(user, obj, options = {})
        options = options.with_indifferent_access
        storage.owner?(user, obj, options)
      end

      def can?(user, scope, action, options = {})
        options = options.with_indifferent_access
        storage.can?(user, scope, action, options)
      end

      def owner_can?(user, obj, scope, action = nil)
        options = options.with_indifferent_access
        scope, action = storage.get_scope_action(obj, scope, action)
        owner?(user, obj) && can?(user, scope, action)
      end

      def permitted_params(controller, options)
        options = options.with_indifferent_access
        storage.permitted_params(controller, options)
      end

      def with_permitted_params(controller, options)
        options   = options.with_indifferent_access
        _params   = options[:params] || controller.params

        permitted = storage.permitted_params(controller, options)

        permitted.each do |item|
          if item.is_a?(Hash)
            key     = item.keys.first
            fields  = item[key]
            _params = _params.require(key).permit(fields)
          else
            _params = _params.permit(item)
          end
        end

        _params
      end

      def permitted_param?(controller, scope, action = nil, options = {})
        permitted = storage.permitted_params(controller, options)

        if action
          ary = find_val_of_hash_item_with_key(permitted, scope)
          ary.try(:include?, action) || false
        else
          permitted.try(:[], scope) || false
        end
      end

      def find_val_of_hash_item_with_key(ary, scope)
        ary.each { |item| return item[scope] if item.is_a?(Hash) && item[scope] }
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
