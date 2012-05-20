require 'yaml'

def settings_file
  Pathname.new(File.expand_path("../../settings.yml", __FILE__))
end

SETTINGS = (File.exists?(settings_file) && yaml= YAML.load_file(settings_file)) ? yaml : {'basic_auth' => 'login:password', 'oauth_token' => 'as79asfd79ads', 'user'=> 'octokat', 'repo' => 'dummy', 'email' => 'email@example.com'}
