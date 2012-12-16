def convert_to_constant(classes)
  constant = Object
  classes.split('::').each do |klass|
    constant = constant.const_get klass
  end
  return constant
end

def unescape(string)
  string.gsub('\n', "\n").gsub('\"', '"').gsub('\e', "\e")
end
