module ServerThinkingSphinx
  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods
    include PathConfig

    def thinking_sphinx_service_state
      pid_file_path = thinking_sphinx_service_pid_file
      ManagementUtil.check_process_by_pid_file(pid_file_path)
    end

    def thinking_sphinx_service_pid_file
      get_pid_rb = File.join(PIN_2012_EDU_PATH,"get_sphinx_pid_file_path.rb")
      return `ruby #{get_pid_rb}`
    end

    def thinking_sphinx_service_start?
      thinking_sphinx_service_state == "正常运行"
    end

    def start_thinking_sphinx_service
      Dir.chdir(SERVERS_SH_PATH){ `bash #{THINKING_SPHINX_SH} start` }
    end

    def stop_thinking_sphinx_service
      Dir.chdir(SERVERS_SH_PATH){ `bash #{THINKING_SPHINX_SH} stop` }
    end

    def restart_thinking_sphinx_service
      Dir.chdir(SERVERS_SH_PATH){ `bash #{THINKING_SPHINX_SH} restart` }
    end
  end

end