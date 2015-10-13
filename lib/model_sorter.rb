require "model_sorter/version"

module ModelSorter
  module Associations
    def self.included(base)
      base.class_eval do
        counter :__serial_number__

        def self.sort_serial_number hsh
          results = self.redis.multi do
            hsh.each do |id, sn|
              self.redis.set "#{self.name.downcase}:#{id}:__serial_number__", sn.to_i
            end
          end
          results.uniq == ["OK"]
        end
      end
    end
  end
end
