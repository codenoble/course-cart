desc 'Run all deployment rake tasks'
task :post_deploy => [
  'maintenance:start',
  'deploy:chef_client',
  'deploy:precompile_assets',
  'deploy:restart_app',
  'deploy:tell_newrelic',
  'maintenance:end'
]
