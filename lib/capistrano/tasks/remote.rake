# rubocop:disable Metrics/BlockLength
namespace :remote do
  desc 'Run and attach to a remote Rails console'
  task :console do
    rails_env = fetch(:rails_env)
    on roles(:db) do |host|
      Capistrano::Remote::Runner.new(host).rails(
        "console -e #{rails_env}"
      )
    end
  end

  desc 'Run and attach to a remote Rails database console'
  task :dbconsole do
    rails_env = fetch(:rails_env)
    on roles(:db) do |host|
      Capistrano::Remote::Runner.new(host).rails(
        "dbconsole #{rails_env} -p"
      )
    end
  end

  desc 'Run a remote rake task.
    Specify the task to run using the `task` environment variable.'
  task :rake do
    rails_env = fetch(:rails_env)
    on roles(:db) do |host|
      Capistrano::Remote::Runner.new(host).rake(
        "RAILS_ENV=#{rails_env} #{ENV['task']}"
      )
    end
  end

  desc 'tail production log files'
  task :tail_logs do
    on roles(:app) do
      trap('INT') { puts 'Interupted'; exit 0; }
      execute "tail -f #{shared_path}/log/production.log" do |channel, stream, data|
        puts # for an extra line break before the host name
        puts "#{channel[:host]}: #{data}"
        break if stream == :err
      end
    end
  end
  
end
# rubocop:enable Metrics/BlockLength
