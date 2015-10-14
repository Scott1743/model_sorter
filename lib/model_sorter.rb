require "model_sorter/version"

module ModelSorter
  # SORT_COLUMN ||= "__serial_number__"
  module Associations
    def self.included(klass)
      klass.class_eval do
        #定义counter
        counter ModelSorter::SORT_COLUMN.to_sym

        # Usage
        #
        # hsh 格式： {"id" => "index" ...}
        # hsh = {2:1, 3:2, 1:3}
        # Klass.sort_serial_number hsh
        # =>
        #   id  |  index
        #    1  |    3
        #    2  |    1
        #    3  |    2
        #
        # ---------------------------------
        #
        # arr 格式： ["id", "id" ...]
        # arr = [1, 2, 3]
        # Klass.sort_serial_number arr
        # =>
        #   id  |  index
        #    1  |    1
        #    2  |    2
        #    3  |    3
        #
        # ---------------------------------
        #
        # 使用ActiveRecord::Relation的实例
        # relation_instance = Klass.all
        # Klass.sort_serial_number relation_instance
        # =>
        #   id  |  index
        #    1  |    1
        #    2  |    2
        #    3  |    3
        #
        # 用Redis批量写入所有klass对象counter
        def self.sort_serial_number serial_list
          results = self.redis.multi do
            case
            when serial_list.is_a?(Hash)
              serial_list.each do |id, sn|
                self.redis.set "#{self.name.downcase}:#{id}:#{ModelSorter::SORT_COLUMN}", sn.to_i
              end
            else
              #Handle Array and ActiveRecord::Relation
              serial_list.each_with_index do |id, index|
                self.redis.set "#{self.name.downcase}:#{id}:#{ModelSorter::SORT_COLUMN}", index + 1
              end
            end
          end
          results.uniq == ["OK"]
        end
      end
    end
  end
end
