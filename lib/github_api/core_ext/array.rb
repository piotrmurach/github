# encoding: utf-8

class Array # :nodoc:

  # Returns a new arrray with keys removed
  #
  def except(*keys)
    self.dup.except!(*keys)
  end unless method_defined? :except

  # Similar to except but modifies self
  #
  def except!(*items)
    copy = self.dup
    copy.reject! { |item| items.include? item }
    copy
  end unless method_defined? :except!

  # Selects a hash from the arguments list
  #
  def extract_options!
    last.is_a?(::Hash) ? pop : {}
  end unless method_defined? :extract_options!

end # Array
