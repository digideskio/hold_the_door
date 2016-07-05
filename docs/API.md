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

#### Permitted Params

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
