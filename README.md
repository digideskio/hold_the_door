# HoldTheDoor

Your last chance to survive!

<center>
  <img src='./docs/hold_the_door2.gif'>
</center>

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

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

