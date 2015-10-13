# ModelSorter

用redis支持ActiveRecord的对象排序，免去在数据库中创建排序字段。

## Installation

Add this line to your application's Gemfile:

    gem 'model_sorter'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install model-sorter

## Usage

组装一个Hash：{ id: index, id: index, ... }

__In your Coffee__

```
    $.ajax(
      type:     'post',
      url:      'update_serial_number',
      data:     { serial_hsh: {5:1, 6:2, 8:3, 1:4, 3:5} },
      dataType: 'text',
      success:  (info) ->
        # ...
    )
```

__In your Model__

```
    class Post < ActiveRecord::Base
      include Redis::Objects
      include ModelSorter::Associations
    end
```

__In your Controller__

用sort_serial_number方法，传入hsh

```
    def index
      @posts = Post.sort_by!{ |p| p.__serial_number__.value }
    end
    
    def update_serial_number
      serial_hsh = params[:serial_hsh]
      if Post.sort_serial_number(serial_hsh)
        return render text: "success"
      else
        return render text: "fail"
      end
    end
```

