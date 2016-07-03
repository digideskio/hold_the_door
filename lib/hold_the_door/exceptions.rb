module HoldTheDoor
  class ActionPermissionRequired < StandardError
    def initialize(data)
      binding.pry
    end
  end

  class OwnerRequired < StandardError
    def initialize(data)
      binding.pry
    end
  end
end
