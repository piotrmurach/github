class Array # :nodoc:

  def except(*keys) # :nodoc:
    self.dup.except!(*keys)
  end unless method_defined?(:except)

  def except!(*items) # :nodoc:
    copy = self.dup
    copy.reject! { |item| items.include? item }
    copy
  end unless method_defined?(:except!)

  def extract_options!
    last.is_a?(::Hash) ? pop : {}
  end

end # Array
