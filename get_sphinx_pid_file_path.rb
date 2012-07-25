require "yaml"

config = YAML.load_file(File.expand_path("../pin-edu-sns/config/sphinx.yml",__FILE__))

edu_project_path = File.expand_path("../",__FILE__)
rails_env = `ruby #{edu_project_path}/parse_property.rb RAILS_ENV`

print config[rails_env]["pid_file"]


