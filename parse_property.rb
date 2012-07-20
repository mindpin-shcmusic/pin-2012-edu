require "yaml"

config = YAML.load_file(File.join(ENV["EDU_PROJECT_PATH"], "property.yaml"))
key = ARGV[0]
value = config[key]
value = value.gsub(/\/$/,"")

if "MINDPIN_MRS_DATA_PATH" == key
  `mkdir -p #{value}/logs`
  `mkdir -p #{value}/sockets`
  `mkdir -p #{value}/pids`
end

print value