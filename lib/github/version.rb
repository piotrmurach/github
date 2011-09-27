module Github 
  module Version
    MAJOR = 0
    MINOR = 1
    PATCH = 0

    STRING = [MAJOR, MINOR, PATCH].compact.join('.');
  end
end
