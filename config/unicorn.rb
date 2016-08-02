worker_processes Integer(ENV["WEB_CONCURRENCY"] || 1)
preload_app true

timeout 60

listen "/var/www/rddt3/current/tmp/sockets/unicorn.sock"
pid "/var/www/rddt3/current/tmp/pids/unicorn.pid"

stderr_path "/var/www/rddt3/current/log/unicorn.stderr.log"
stdout_path "/var/www/rddt3/current//log/unicorn.stdout.log"

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
