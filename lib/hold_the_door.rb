require_relative '../version'

require 'hold_the_door/base'
require 'hold_the_door/exceptions'
require 'hold_the_door/view_helpers'
require 'hold_the_door/model_helpers'

module HoldTheDoor
  class Engine < Rails::Engine
    config.autoload_paths << "#{ config.root }/app/permissions/**"

    initializer :'hold_the_door.helpers' do
      ActiveSupport.on_load(:action_controller) do
        class ActionController::Base
          include HoldTheDoor::ViewHelpers
        end
      end

      ActiveSupport.on_load(:action_view) do
        class ActionView::Base
          include HoldTheDoor::ViewHelpers
        end
      end
    end
  end
end
