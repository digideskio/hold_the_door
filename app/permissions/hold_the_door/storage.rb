class HoldTheDoor::Storage
  include HoldTheDoor::StorageBase

  include HoldTheDoor::ACL
  include HoldTheDoor::Ownership
  include HoldTheDoor::PermittedParams
end
