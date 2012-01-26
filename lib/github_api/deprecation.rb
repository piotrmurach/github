# encoding: utf-8

module Github

  DEPRECATION_PREFIX = "[GithubAPI] Deprecation warning:"

  class << self

    attr_writer :deprecation_tracker

    def deprecation_tracker
      @deprecation_tracker ||= []
    end

    # Displays deprecation message to the user.
    # Each message is printed once.
    def deprecate(method, alternate_method=nil)
      return if deprecation_tracker.include? method
      deprecation_tracker << method

      message = <<-NOTICE
#{DEPRECATION_PREFIX}

* #{method} is deprecated.
NOTICE
      if alternate_method
        message << <<-ADDITIONAL
* please use #{alternate_method} instead.
ADDITIONAL
      end
      warn_deprecation(message)
    end

    def warn_deprecation(message)
      send :warn, message
    end
  end

end # Github
