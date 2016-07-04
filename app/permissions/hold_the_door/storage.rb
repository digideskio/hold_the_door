class HoldTheDoor::Storage
  class Instance
    include HoldTheDoor::StorageBase

    include HoldTheDoor::ACL
    include HoldTheDoor::Ownership
    include HoldTheDoor::PermittedParams
  end

  def self.instance
    @storage ||= ::HoldTheDoor::Storage::Instance.new
  end

  private_class_method :new
end
