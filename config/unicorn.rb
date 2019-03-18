worker_processes Integer(ENV["WEB_CONCURRENCY"] || 3)
timeout 15
preload_app true

APP_PATH = "/project/www/verifyamltoken"
working_directory APP_PATH

stderr_path APP_PATH + "/log/unicorn.log"
stdout_path APP_PATH + "/log/unicorn.log"

pid APP_PATH + "/tmp/pids/unicorn.pid"

listen APP_PATH + "/tmp/sockets/unicorn.staging.sock"

before_fork do |server, worker|
      Signal.trap 'TERM' do
              puts 'Unicorn master intercepting TERM and sending myself QUIT instead'
                  Process.kill 'QUIT', Process.pid
                    end

        defined?(ActiveRecord::Base) and
            ActiveRecord::Base.connection.disconnect!
end

after_fork do |server, worker|
      Signal.trap 'TERM' do
              puts 'Unicorn worker intercepting TERM and doing nothing. Wait for master to send QUIT'
                end

        defined?(ActiveRecord::Base) and
            ActiveRecord::Base.establish_connection
end
