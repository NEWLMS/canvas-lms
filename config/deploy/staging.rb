set :stage, :production
set :branch, 'master'
set :rails_env, 'production'

# Simple Role Syntax
# ==================
# Supports bulk-adding hosts to roles, the primary
# server in each group is considered to be the first
# unless any hosts have the primary property set.
role :db, %w(198.199.100.89), primary: true


server '198.199.100.89', user: 'admin', roles: %w(app web)
