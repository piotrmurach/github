class Hash # :nodoc:

  def except(*items) # :nodoc:
    self.dup.except!(*items)
  end unless method_defined?(:except)

  def except!(*keys) # :nodoc:
    copy = self.dup
    keys.each { |key| copy.delete!(key) }
    copy
  end unless method_defined?(:except!)

  def symbolize_keys  # :nodoc:
    inject({}) do |hash, (key, value)|
      hash[(key.to_sym rescue key) || key] = value
      hash
    end
  end unless method_defined?(:symbolize_keys)

  def symbolize_keys! # :nodoc:
    hash = symbolize_keys
    hash.each do |key, val|
      hash[key] = case val
        when Hash
          val.symbolize_keys!
        when Array
          val.map do |item|
            item.is_a?(Hash) ? item.symbolize_keys! : item
          end
        else
          val
        end
    end
    return hash
  end unless method_defined?(:symbolize_keys!)

  def serialize # :nodoc:
    self.map { |key, val| [key, val].join("=") }.join("&")
  end unless method_defined?(:serialize)

  def all_keys # :nodoc:
    keys = self.keys
    keys.each do |key|
      if self[key].is_a?(Hash)
        keys << self[key].all_keys.compact.flatten
        next
      end
    end
    keys.flatten
  end unless method_defined?(:all_keys)

  def has_deep_key?(key)
    self.all_keys.include? key
  end unless method_defined?(:has_deep_key?)

end # Hash
