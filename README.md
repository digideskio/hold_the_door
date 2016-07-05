# HoldTheDoor!

Hold The Door! Don't pass the dark forces!

<table>
<tr>
  <td>
    <img src='./docs/hold_the_door2.gif'>
  </td>
  <td>
    <img src='./docs/hold_the_door.gif'>
  </td>
</tr>
</table>

## Intro

HoldTheDoor! Authorization Framework for Rails 5

Authorization solution created for modern Rails Apps

**Provides:** ACL + Ownership + Permitted Params<sup>&beta;</sup>

## How my Controllers will look with HoldTheDoor gem?

For demo purposes we use just `edit` action here

```ruby
class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  hold_the_door!
end
```

```ruby
class PagesController < ApplicationController
  authorize_resource_name :editable_page

  before_action :set_page
  before_action :authorize_owner!

  def edit
    @editable_page.update with_permitted_params

    redirect_to :back, notice: 'Page was updated'
  end

  private

  def set_page
    @editable_page = Page.find params[:id]
  end
end
```

## How my Views will look with HoldTheDoor gem?

```slim
= form_for @page do |f|
    .field
      = f.label :title
      = f.text_field :title

    .field
      = f.label :content
      = f.text_area :content

  - if can?(@page, :update_user)
      .field
        = f.label :user_id
        = f.text_field :user_id

  - if permitted_param?(@page, :moderation_comment)
      .field
        = f.label :moderation_comment
        = f.text_area :moderation_comment

  .actions
    = f.submit 'Submit'
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
    acl.first.try(:[], scope).try(:include?, action) || false
  end

  def user_acl
    [
      pages: [
        :index,
        :show,
        :edit
      ],
      accounts: [
        :index,
        :show
      ]
    ]
  end

  def guest_acl
    []
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
    user   = controller.current_user
    controller_name = controller.controller_name

    case controller_name
      when 'pages'
        pages_params(user)
      when 'accounts'
        accounts_params(user)
      else
        []
    end
  end

  private

  def pages_params(user)
    if user.admin?
      # Admin can change page's user
      # and leave a moderation comment
      [
        page: [
          :title,
          :content,
          :state,

          :user_id,
          :moderation_comment,
        ]
      ]
    else
      [
        page: [
          :title,
          :content,
          :state
        ]
      ]
    end
  end

  def accounts_params(user)
    []
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

#### ACL checking

```ruby
current_user.can?(:pages, :edit)
# or shortcut
can?(:pages, :edit)
# or
can?(Page, :edit)
```

#### Ownership checking

```ruby
current_user.owner?(@page)
# or shortcut
owner?(@page)
```

#### Both ACL and Ownership checking

```ruby
current_user.owner_can?(@page, :pages, :edit)
# or with shortcuts
owner_can?(@page, :pages, :edit)
# or
owner_can?(@page, :edit)
# or
can?(@page, :edit)
```

#### Permitted Parameters

```ruby
with_permitted_params
```

```ruby
def edit
  @my_page.update with_permitted_params

  redirect_to :back, notice: 'Page was updated'
end
```

```ruby
current_user.permited_param?(:page, :title)
# or shortcut
permitted_param?(:page, :title)
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

  before_action :set_page
  before_action :authorize_owner!
end
```

or more obviously

```ruby
class PagesController < ApplicationController
  before_action :set_page
  before_action ->{ authorize_owner!(@page) }
end
```

#### Permitted params

```ruby
class PagesController < ApplicationController
  def edit
    @page.update with_permitted_params
    redirect_to :back, notice: 'Page was updated'
  end
end
```

## Full Authentication/Authorization process

Just for Demo purposes

```ruby
class PagesController < ApplicationController
  authorize_resource_name :my_page

  before_action :authenticate_user!  # Step 1
  before_action :authorize_action!   # Step 2
  before_action :set_page            # Step 3
  before_action :authorize_owner!    # Step 4

  def edit
    # Step 5
    @my_page.update with_permitted_params

    redirect_to :back, notice: 'Page was updated'
  end

  private

  def set_page
    @my_page = Page.find params[:id]
  end
end
```

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

    redirect_to :back, notice: 'Page was updated'
  end

  private

  def set_page
    @page = Page.find params[:id]
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

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

