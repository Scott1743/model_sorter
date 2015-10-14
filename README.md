# ModelSorter

用 Redis 来支持 ActiveRecord 或 DataMapper 的等 Ruby ORM 对象排序，免去在文件数据库中使用排序字段。

## Installation

Add this line to your application's Gemfile:

    gem 'model_sorter'
    
Name your column, add this to 'config/initializes/model_sorter.rb'
```
module ModelSorter
  SORT_COLUMN = "what_column_you_want"
end
```
## Usage

As：需要 View 中配置 Post 结果集的对象排序（用 jquery-ui.sortable 等组件）。

__In your Model__

```
class Post < ActiveRecord::Base
  include Redis::Objects
  include ModelSorter::Associations
end
```

__In your Coffee__

组装出 Hash 

    hsh: { id: index, id: index, ... }
    
或 Array, 按你希望的顺序由小到大
  
    arr: [ id, id,  ... ] 

```
$.ajax(
  type:     '...',
  url:      '...',
  data:     { serial_list: [5, 3, 4, 2, ...] },
  dataType: '...',
  success:  () ->
    # ...
)
```

__In your Controller__

用sort_serial_number方法，传入Hash, Array, ActiveRecord::Relation ...

```
def index
  @posts = Post.sort_by!{ |p| p.ur_column_name.value }
end

def update_serial_number
  serial_list = params[:serial_list]
  
  # if Post.sort_serial_number(Post.all)
  
  if Post.sort_serial_number(serial_list)
    return render text: "success"
  else
    return render text: "fail"
  end
end
```

## Note

1. 出现这个错误？请再看 Installation

    uninitialized constant ModelSorter::SORT_COLUMN (NameError)
    
2. 使用 DataMapper 需有 id 字段    
    




