# HoldTheDoor

<table>
<tr>
  <td>
    <img src='./docs/hold_the_door.gif'>
  </td>
  <td>
    <img src='./docs/hold_the_door2.gif'>
  </td>
</tr>
</table>

Hold The Door! Don't miss the dark forces!

## Intro

HoldTheDoor! Authorization Framework for Rails 5

Provides: ACL + Ownership + Permitted Params

## Full Authentication/Authorization process in Rails

0. Authenticate user (Authentication solution: Devise, Sorcery, Authlogic, etc.)
0. **Access Permission to Action** (Authorization solution)
0. Load resourse (Application level)
0. **Ownership checking** (Authorization solution)
0. **Definition of Permitted Params** (Authorization solution)

### An Example

For simplicity just `edit` action will be illustrated here

```ruby
class PagesController < ApplicationController
  # 1. Authentication process (Devise)
  before_action :authenticate_user!

  # 2. Access Permission to Action
  # Does a user have an access to Action in Controller?
  # CanCan: `authorize! :edit, Page`
  before_action ->{ authorize_action!(:pages, :edit) }

  # 3. Load resource
  # CanCan: `load_resource`
  before_action :set_page

  # 4. Ownership checking (now we have a resource and we can check it)
  # Is it an owner of this object? Can user update it?
  # CanCan mixes it with ACL definitions in Ability class :'(
  before_action ->{ authorize_owner!(@page) }

  def edit
    # 5. `pages_params` - Definition of Permitted Params
    # See definition of `pages_params` below
    #
    # CanCan was never ready for Strong Params,
    # because CanCan was created before Strong Params
    #
    @page.update pages_params

    redirect_to :back, notice: 'Page updated'
  end

  private

  def set_page
    Page.find params[:id]
  end

  # 5. Definition of Permitted Params
  def pages_params
    if current_user.admin?
      params.require(:page)
        .permit(
          :title,
          :content,
          :state,

          :user_id,
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
end
```

## How my Controller will be looked with HoldTheDoor gem?

```ruby
class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  # Close and Hold all Doors!
  hold_the_door!
end
```

```ruby
class PagesController < ApplicationController
  before_action :set_page

  authorize_resource_name :page
  before_action authorize_owner!

  def edit
    @page.update permitted_params
    redirect_to :back, notice: 'Page updated'
  end

  private

  def set_page
    Page.find params[:id]
  end
end
```

### Installation

```ruby
gem 'hold_the_door'
```

```ruby
rake install:hold_the_door
```

### File structure

```
app/permissions/
└── hold_the_door
    ├── acl.rb
    ├── ownership.rb
    └── permitted_params.rb
```

### ACL Definition

```ruby
module HoldTheDoor::ACL
  def can?(user, scope, action, options)
    # Admin can do everything
    return true if user.try(:admin?)

    role_name = user.try(:role) || 'guest'

    # Get ACL (Acceess Control List) for this Role
    acl = case role_name
      when 'user'
        user_acl
      else
        guest_acl
    end

    # Does user have this permission or not?
    # It returns `true` if testable rule is exist
    acl_check(acl, scope, action)
  end

  private

  def acl_check(acl, scope, action)
    acl.try(:[], scope).try(:include?, action) || false
  end

  def user_acl
    {
      pages: [
        :index,
        :show,
        :edit
      ],
      accounts: [
        :index,
        :show
      ]
    }
  end

  def guest_acl
    {}
  end
end
```

### Ownership Definition

```ruby
module HoldTheDoor::Ownership
  def owner?(user, obj, options)
    # Admin is owner of everything
    return true if user.admin?

    # Simple ownership check
    user.id == obj.user_id
  end
end
```

### Permitted Params Definition

```ruby
module HoldTheDoor::PermittedParams
  def permitted_params(controller, options)
    params = controller.params
    user   = controller.current_user
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
      # Admin can change page's user
      # and leave a moderation comment
      params.require(:page)
        .permit(
          :title,
          :content,
          :state,

          :user_id,
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
```

## API

### Model

```ruby
class User < ApplicationRecord
  include HoldTheDoor::ModelHelpers
end

@user = User.find(1)
@page = Page.find(1)
```

```ruby
# ACL checking
@user.can?(:pages, :edit)
# or
@user.can?(Page, :edit)
```

```ruby
# Ownership checking
@user.owner?(@page)
```

```ruby
# Both ACL and Ownership checking
@user.owner_can?(@page, :pages, :edit)
# or shortcut
@user.owner_can?(@page, :edit)
# or shortcut
@user.can?(@page, :edit)
```

### Controller/Views

```ruby
# ACL checking
current_user.can?(:pages, :edit)
# or shortcut
can?(:pages, :edit)
# or
can?(Page, :edit)
```

```ruby
# Ownership checking
current_user.owner?(@page)
# or shortcut
owner?(@page)
```

```ruby
# Both ACL and Ownership checking
current_user.owner_can?(@page, :pages, :edit)
# or with shortcuts
owner_can?(@page, :pages, :edit)
# or
owner_can?(@page, :edit)
# or
can?(@page, :edit)
```

### Before filters

#### Main door holder

```ruby
class ApplicationController < ActionController::Base
  hold_the_door!
  # it's equal to:
  #
  # before_action :authenticate_user! (will be added only if you use Devise)
  # before_action :authorize_action!
end
```

#### Ownership checking

```ruby
class PagesController < ApplicationController
  authorize_resource_name :page

  before_action :set_page, only: :edit
  before_action authorize_owner!, only: :edit
end
```

or more obviously

```ruby
class PagesController < ApplicationController
  before_action :set_page, only: :edit
  before_action ->{ authorize_owner!(@page) }, only: :edit
end
```

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

