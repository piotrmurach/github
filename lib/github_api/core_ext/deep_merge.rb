class Hash
  def deep_merge(other)
    dup.deep_merge!(other)
  end

  def deep_merge!(other)
    other.each_pair do |key, val|
      tval = self[key]
      self[key] = tval.is_a?(Hash) && val.is_a?(Hash) ? tval.deep_merge(val) : val
    end
    self
  end
end
