require File.expand_path(File.dirname(__FILE__) + "/environment")
job_type :runner, "cd #{Rails.root.to_s} && /usr/local/rvm/wrappers/ruby-2.2.1@rddt3/rails runner -e :environment ':task' :output"
set :output, Rails.root.join('log','cron.log').to_s

every 4.hours do
  runner "AllSync.update"
end
