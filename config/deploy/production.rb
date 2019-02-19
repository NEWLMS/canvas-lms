set :stage, :production
set :branch, 'master'
set :rails_env, 'production'

# Simple Role Syntax
# ==================
# Supports bulk-adding hosts to roles, the primary
# server in each group is considered to be the first
# unless any hosts have the primary property set.
role :db, %w(192.241.235.176), primary: true


server '192.241.235.176', user: 'admin', roles: %w(app web)
server '192.241.219.110', user: 'admin', roles: %w(app web)
