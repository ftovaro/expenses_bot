release: bundle exec rake db:migrate
worker: bundle exec sidekiq -c 1 -q default
web: bin/rails server -p ${PORT:-5000} -e $RAILS_ENV