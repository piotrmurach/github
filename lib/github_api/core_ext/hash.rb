class Hash # :nodoc:

  def except(*items) # :nodoc:
    puts "array except works!!!"
    self.dup.except!(*items)
  end unless method_defined?(:except)

  def except!(*keys) # :nodoc:
    copy = self.dup
    keys.each { |key| copy.delete!(key) }
    copy
  end unless method_defined?(:except!)

end # Hash
