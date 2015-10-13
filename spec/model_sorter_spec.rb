#encoding: UTF-8
require "redis-objects"

$LOAD_PATH.unshift File.expand_path(File.dirname(__FILE__) + '/../lib')
require "model_sorter"

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

  it "save_serial_number" do
    User.sort_serial_number @hsh

    arr = @users.map do |u|
      u.__serial_number__.value
    end
    expect(arr).to eq([5, 4, 3, 2, 1])
  end
end