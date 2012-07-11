module PathConfig
  PIN_2012_PATH = File.join(File.dirname(File.expand_path(__FILE__)),"../../")

  UNICORN_SH_PATH = File.join(PIN_2012_PATH,"sh")
  WORKER_SH_PATH = File.join(PIN_2012_PATH,"sh/worker_sh")
  SERVERS_SH_PATH = File.join(PIN_2012_PATH,"sh/service_sh")

  REDIS_SERVICE_SH = File.join(SERVERS_SH_PATH,"redis_service.sh")
  RESQUE_WEB_SH = File.join(SERVERS_SH_PATH,"resque_web_service.sh")
  JUGGERNAUT_SH = File.join(SERVERS_SH_PATH,"juggernaut_service.sh")

  PROJECTS = Dir.entries(File.join(PIN_2012_PATH,"apps")).delete_if{|app|app == "." || app == ".."}
end
