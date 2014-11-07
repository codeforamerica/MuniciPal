namespace :app do
  desc "Run the top level rake tasks necessary to get setup upon first deployment"
  task :deploy => ['db:migrate', 'legistar_all:refresh']
end
