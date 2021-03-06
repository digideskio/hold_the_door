# HoldTheDoor!

Hold The Door! Don't pass the dark forces!

<table>
<tr>
  <td>
    <img src='docs/images/hold_the_door2.gif'>
  </td>
  <td>
    <img src='docs/images/hold_the_door.gif'>
  </td>
</tr>
</table>

### Intro

HoldTheDoor! Authorization Framework for Rails 5 created special for modern Rails Apps

**Provides:** ACL + Ownership + Permitted Params<sup>&beta;</sup>

### How my Controllers will look with HoldTheDoor gem?

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

### How my Views will look with HoldTheDoor gem?

For Demo purposes we use SLIM template language here

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

## Installation

#### 1. Add gem in you Gemfile

```ruby
gem 'hold_the_door'
```

#### 2. Bundle install

```ruby
bundle install
```

#### 3. Install required files

```ruby
rake install:hold_the_door
```

It will add `config/initializers/hold_the_door.rb`

And create the following **file structure**

```
app/permissions/
└── hold_the_door
    ├── acl.rb
    ├── ownership.rb
    └── permitted_params.rb
```

#### 4. Define ACL logic

* [How to define ACL logic](docs/Define-ACL-logic.md)

#### 5. Define Ownership logic

* [How to define Ownership logic](docs/Define-Ownership-logic.md)

#### 6. Define Permitted Params<sup>&beta;</sup> logic

* [How to define Permitted Params<sup>&beta;</sup> logic](docs/Define-Permitted_Params-logic.md)

#### 7. Learn the API

* [Model API](docs/API.md)
* [Controller/View API](docs/API.md)
* [Permitted Params API](docs/API.md)

## FAQ

* [Why HoldTheDoor is an Authorization Framework?](docs/FAQ.md)
* [What does it mean ACL?](docs/FAQ.md)
* [Why I have to try HoldTheDoor instead CanCan?](docs/FAQ.md)
* [What does it mean &beta; in `Permitted Params` functionality?](docs/FAQ.md)
* [How typical Authentication/Authorization process goes in Rails?](docs/FAQ.md)
* [Where I can find the Demo App for HoldTheDoor?](docs/FAQ.md)
* [How can I start tests?](docs/FAQ.md)

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

