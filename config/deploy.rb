set :application, 'canvas-lms'
set :repo_url,  'git@github.com:NEWLMS/canvas-lms.git'
set :deploy_to, '/var/www/applications/canvas-lms'

set :rbenv_type, :user
set :rbenv_ruby, File.read('.ruby-version').strip
set :rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec"
set :rbenv_map_bins, %w[rake gem bundle ruby rails  haml]
set :rbenv_roles, %i[app web]


# Capistrano seems to assume shared dir under
# /var/www/ems - overiding default_shared path
set :shared_path, File.join(deploy_to, 'shared')

set :scm, :git
set :ssh_options, forward_agent: true, keepalive: true
set :log_level, :debug

# slack Settings


SSHKit.config.command_map[:rake]  = 'bundle exec rake'
SSHKit.config.command_map[:rails] = 'bundle exec rails'
set :linked_files, %w[config/database.yml config/amazon_s3.yml
  config/delayed_jobs.yml config/domain.yml
  config/file_store.yml config/outgoing_mail.yml
  config/security.yml config/external_migration.yml
  config/dynamic_settings.yml]
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
