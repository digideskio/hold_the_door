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

### Intro

HoldTheDoor! Authorization Framework for Rails 5

Authorization solution created special for modern Rails Apps

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

* [How to define ACL logic](http://example.com)

#### 5. Define Ownership logic

* [How to define Ownership logic](http://example.com)

#### 6. Define Permitted Params<sup>&beta;</sup> logic

* [How to define Permitted Params<sup>&beta;</sup> logic](http://example.com)

#### 7. Learn the API

* [Model API](http://example.com)
* [Controller/View API](http://example.com)
* [Permitted Params API](http://example.com)

## FAQ

* [Why HoldTheDoor is a Authorization Framework?](http://example.com)
* [What does it mean ACL?](http://example.com)
* [Why I have to try HoldTheDoor instead CanCan?](http://example.com)
* [What does it mean &beta; in `Permitted Params` functionality?](http://example.com)
* [How typical Authentication/Authorization process goes in Rails?](http://example.com)

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

