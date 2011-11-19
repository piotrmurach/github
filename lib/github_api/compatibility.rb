# coding: utf-8

if RUBY_VERSION < "1.9"

  def ruby_18 #:nodoc:
    yield
  end

  def ruby_19 #:nodoc:
    false
  end

else

  def ruby_18 #:nodoc:
    false
  end

  def ruby_19 #:nodoc:
    yield
  end

end
