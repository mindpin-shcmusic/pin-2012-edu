# worker 数量
worker_processes 3

BASE_PATH = '/web/2012'

stderr_path(File.join BASE_PATH, 'logs', 'unicorn-management-error.log')
stdout_path(File.join BASE_PATH, 'logs', 'unicorn-management.log')

preload_app true
timeout 30
listen File.join(BASE_PATH, 'sockets', 'unicorn-management.sock'), :backlog => 2048

pid_file_name = File.join(BASE_PATH, 'pids', 'unicorn-management.pid')
pid pid_file_name

if GC.respond_to?(:copy_on_write_friendly=)
  GC.copy_on_write_friendly = true
end

before_fork do |server, worker|
  old_pid = pid_file_name + '.oldbin'
  if File.exists?(old_pid) && server.pid != old_pid
    begin
      Process.kill("QUIT", File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
      # ...
    end
  end
end

after_fork do |server, worker|
end