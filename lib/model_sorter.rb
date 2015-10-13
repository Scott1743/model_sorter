require "model_sorter/version"

module ModelSorter
  # SORT_COLUMN ||= "__serial_number__"
  module Associations
    def self.included(klass)
      klass.class_eval do
        #定义counter
        counter ModelSorter::SORT_COLUMN.to_sym

        #Redis批量写入所有klass对象counter
        def self.sort_serial_number hsh
          results = self.redis.multi do
            hsh.each do |id, sn|
              self.redis.set "#{self.name.downcase}:#{id}:#{ModelSorter::SORT_COLUMN}", sn.to_i
            end
          end
          results.uniq == ["OK"]
        end
      end
    end
  end
end
