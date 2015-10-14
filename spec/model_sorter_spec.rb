#encoding: UTF-8
require "redis-objects"

$LOAD_PATH.unshift File.expand_path(File.dirname(__FILE__) + '/../lib')

require "model_sorter"

module ModelSorter
  SORT_COLUMN = "ex_column"
end

Redis.current = Redis.new(:host => '127.0.0.1', :port => 6379)

describe ModelSorter do

  class User
    include Redis::Objects
    include ModelSorter::Associations

    attr_accessor :id

    def initialize args
      @id = args.fetch(:id)
    end
  end

  before :each do
    @users = []
    @hsh = {}
    i = 1
    5.times do
      @users << User.new(id: i)
      @hsh[i] = 6 - i
      i += 1
    end
  end

  it "set User's all serial_number to redis" do
    User.sort_serial_number @hsh

    arr = @users.map do |u|
      u.ex_column.value
    end
    expect(arr).to eq([5, 4, 3, 2, 1])
  end

  it "handle serial_number is Array" do
    User.sort_serial_number @hsh.keys

    arr = @users.sort_by{ |u| u.ex_column.value }.map{|u| u.id}
    expect(arr).to eq([1, 2, 3, 4, 5])
  end

end