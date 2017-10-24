# encoding: utf-8

class Hash # :nodoc:

  # Returns a new hash with keys removed
  #
  def except(*items)
    self.dup.except!(*items)
  end unless method_defined? :except

  # Similar to except but modifies self
  #
  def except!(*keys)
    keys.each { |key| delete(key) }
    self
  end unless method_defined? :except!

  # Returns a new hash with all the keys converted to symbols
  #
  def symbolize_keys
    inject({}) do |hash, (key, value)|
      hash[(key.to_sym rescue key) || key] = value
      hash
    end
  end unless method_defined? :symbolize_keys

  # Similar to symbolize_keys but modifies self
  #
  def symbolize_keys!
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
  end unless method_defined? :symbolize_keys!

  # Returns hash collapsed into a query string
  #
  def serialize
    self.map { |key, val| [key, val].join("=") }.join("&")
  end unless method_defined? :serialize

  # Searches for all deeply nested keys
  #
  def deep_keys
    keys = self.keys
    keys.each do |key|
      if self[key].is_a?(Hash)
        keys << self[key].deep_keys.compact.flatten
        next
      end
    end
    keys.flatten
  end unless method_defined? :deep_keys

  # Returns true if the given key is present inside deeply nested hash
  #
  def deep_key?(key)
    self.deep_keys.include? key
  end unless method_defined? :deep_key?

  # Recursively merges self with other hash and returns new hash.
  #
  def deep_merge(other, &block)
    dup.deep_merge!(other, &block)
  end unless method_defined? :deep_merge

  # Similar as deep_merge but modifies self
  #
  def deep_merge!(other, &block)
    other.each_pair do |key, val|
      tval = self[key]
      if tval.is_a?(Hash) && val.is_a?(Hash)
        self[key] = tval.deep_merge(val)
      else
        self[key] = block && tval ? block.call(k, tval, val) : val
      end
    end
    self
  end unless method_defined? :deep_merge!

end # Hash
