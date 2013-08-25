module TradeKing
  class Collection

    def initialize(options={})
      puts options.inspect
      fields.each do |field |
        if options[field].present?
          self.class.__send__(:attr_accessor, field.to_sym)
          self.instance_variable_set("@#{field}", self.class.cast(options[field]))
        end
      end
    end
    
    def self.cast(value)
      if value.is_a?(String)
        value.to_fs
      elsif value.is_a?(Array)
        value.map{|v| cast(v) }
      end
    end

    def fields
      []
    end

    def self.parse_collection(options={})
      options['quotes']['quote']
    end
  end
end