module ServerJuggernaut
  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods
    include PathConfig

    def juggernaut_service_state
      pid_file_path = "/web/2012/pids/juggernaut_service.pid"
      ManagementUtil.check_process_by_pid_file(pid_file_path)
    end

    def juggernaut_service_start?
      juggernaut_service_state == "正常运行"
    end

    def start_juggernaut_service
      Dir.chdir(SERVERS_SH_PATH){ `bash #{JUGGERNAUT_SH} start` }
    end

    def stop_juggernaut_service
      Dir.chdir(SERVERS_SH_PATH){ `bash #{JUGGERNAUT_SH} stop` }
    end

    def restart_juggernaut_service
      Dir.chdir(SERVERS_SH_PATH){ `bash #{JUGGERNAUT_SH} restart` }
    end
  end
end