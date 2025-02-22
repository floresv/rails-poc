# frozen_string_literal: true

namespace :code do
  desc 'Run code quality tools'
  task analysis: :environment do
    # sh 'bundle exec brakeman . -z -q'
    # sh 'bundle exec reek .'
    # sh 'bundle exec rails_best_practices .'
    # sh 'bundle exec i18n-tasks health'
    sh 'bundle exec rubocop .'
  end
end
