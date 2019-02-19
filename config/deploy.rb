set :application, 'ems'
set :repo_url,  'git@github.com:NEWLMS/EMS32.git'
set :deploy_to, '/var/www/applications/ems'

set :rbenv_type, :user
set :rbenv_ruby, File.read('.ruby-version').strip
set :rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec"
set :rbenv_map_bins, %w[rake gem bundle ruby rails sidekiq sidekiqctl haml]
set :rbenv_roles, %i[app web sidekiq]

set :whenever_identifier, -> { "#{fetch(:application)}_#{fetch(:stage)}" }
set :whenever_roles, %i[app sidekiq]
set :sidekiq_monit_conf_dir, '/etc/monit/conf.d'
set :sidekiq_monit_use_sudo, true

# Capistrano seems to assume shared dir under
# /var/www/ems - overiding default_shared path
set :shared_path, File.join(deploy_to, 'shared')

set :scm, :git
set :ssh_options, forward_agent: true, keepalive: true
set :log_level, :debug

# slack Settings


SSHKit.config.command_map[:rake]  = 'bundle exec rake'
SSHKit.config.command_map[:rails] = 'bundle exec rails'
set :linked_files, %w[config/database.yml .env]
set :linked_dirs, %w[
  log
  public/system
  tmp/cache
  tmp/pids
  tmp/sockets
  vendor/bundle
  node_modules
]

# set :default_env, { path: "/opt/ruby/bin:$PATH" }
# set :keep_releases, 5
set :keep_snapshots, 10

namespace :deploy do
  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      # Your restart mechanism here, for example:
      execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

  after 'deploy:publishing', 'deploy:restart'
  after 'finishing',         'deploy:cleanup'
end
