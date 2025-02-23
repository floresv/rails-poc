# Rails PoC - FoodAPI

This API provides a comprehensive interface for managing food-related data, including meal categories, individual meals, orders and payments. It serves as a backend system for applications requiring structured food information management and order processing. Built with Ruby on Rails, this API implements RESTful principles and includes thorough documentation of all endpoints.

## Features

Key features:
- RESTful API endpoints for managing meals and categories
- Order creation and payment processing
- Wishlist management endpoints for saving favorite items
- Admin interface for managing all resources
- User authentication and authorization
- Pagination and filtering support
- Comprehensive error handling
- API documentation

API_URL=https://rails-poc-k1uu.onrender.com/api/v1

Admin API docs:
https://rails-poc-k1uu.onrender.com/api-docs
username: apifood
password: password

ActiveAdmin:
https://rails-poc-k1uu.onrender.com/admin
username: admin@example.com
password: password

## How to use with Docker

To run this API locally with Docker Compose:

1. Clone the repository
2. Copy the .env.example file to .env and configure environment variables:
   ```bash
   cp .env.example .env
   ```
3. Build the Docker images:
   ```bash
   docker-compose build
   ```
4. Start the services:
   ```bash
   docker-compose up
   ```
5. Create and setup the database:
   ```bash
   docker-compose exec web rails db:create db:migrate
   ```
6. Optionally seed the database with sample data:
   ```bash
   docker-compose exec web rails db:seed
   ```

The API will be available at http://localhost:3000


See [Docker docs](./docs/docker.md) for more info

## Dev scripts

This template provides a handful of scripts to make your dev experience better!

- bin/bundle to run any `bundle` commands.
  - `bin/bundle install`
- bin/rails to run any `rails` commands
  - `bin/rails console`
- bin/web to run any `bash` commands
  - `bin/web ls`
- bin/rspec to run specs
  - `bin/rspec .`
- bin/dev to run both Rails and JS build processes at the same time in a single terminal tab.
  - `bin/dev`

You don't have to use these but they are designed to run the same when running with Docker or not.
To illustrate, `bin/rails console` will run the console in the docker container when running with docker and locally when not.

## Gems

- [ActiveAdmin](https://github.com/activeadmin/activeadmin) for easy administration
- [Arctic Admin](https://github.com/cprodhomme/arctic_admin) for responsive active admin
- [Annotate](https://github.com/ctran/annotate_models) for documenting the schema in the classes
- [Better Errors](https://github.com/charliesome/better_errors) for a better error page
- [Brakeman](https://github.com/presidentbeef/brakeman) for security static analysis
- [Byebug](https://github.com/deivid-rodriguez/byebug) for debugging
- [DelayedJob](https://github.com/collectiveidea/delayed_job) for background processing
- [Devise](https://github.com/plataformatec/devise) for basic authentication
- [Devise Token Auth](https://github.com/lynndylanhurley/devise_token_auth) for API authentication
- [Dotenv](https://github.com/bkeepers/dotenv) for handling environment variables
- [Draper](https://github.com/drapergem/draper) for decorators
- [Factory Bot](https://github.com/thoughtbot/factory_bot) for testing data
- [Faker](https://github.com/stympy/faker) for generating test data
- [Flipper](https://github.com/jnunemaker/flipper) for feature flag support
- [Jbuilder](https://github.com/rails/jbuilder) for JSON views
- [JS Bundling](https://github.com/rails/jsbundling-rails) for bundling JS assets
- [Knapsack](https://github.com/KnapsackPro/knapsack) for splitting tests evenly based on execution time
- [Letter Opener](https://github.com/ryanb/letter_opener) for previewing emails in the browser
- [New Relic](https://github.com/newrelic/newrelic-ruby-agent) for monitoring and debugging
- [Pagy](https://github.com/ddnexus/pagy) for pagination
- [Parallel Tests](https://github.com/grosser/parallel_tests) for running the tests in multiple cores
- [Prosopite](https://github.com/charkost/prosopite) to detect N+1 queries
- [Pry](https://github.com/pry/pry) for enhancing the Ruby shell
- [Puma](https://github.com/puma/puma) for the web server
- [Pundit](https://github.com/varvet/pundit) for authorization management
- [Rack CORS](https://github.com/cyu/rack-cors) for handling CORS
- [Rails Best Practices](https://github.com/flyerhzm/rails_best_practices) for Rails linting
- [Reek](https://github.com/troessner/reek) for Ruby linting
- [RSpec](https://github.com/rspec/rspec) for testing
- [RSpec OpenAPI](https://github.com/exoego/rspec-openapi) for generating API documentation
- [Rswag](https://github.com/rswag/rswag) for serving the API documentation
- [Rubocop](https://github.com/bbatsov/rubocop/) for Ruby linting
- [Sendgrid](https://github.com/stephenb/sendgrid) for sending emails
- [Shoulda Matchers](https://github.com/thoughtbot/shoulda-matchers) for other testing matchers
- [Simplecov](https://github.com/colszowka/simplecov) for code coverage
- [Strong Migrations](https://github.com/ankane/strong_migrations) for catching unsafe migrations in development
- [Webmock](https://github.com/bblimke/webmock) for stubbing http requests
- [YAAF](https://github.com/rootstrap/yaaf) for form objects

## API Docs

- [RSpec API Doc Generator](https://github.com/exoego/rspec-openapi) you can generate the docs after writing requests specs
- [Rswag](https://github.com/rswag/rswag) you can expose the generated docs

See [API documentation docs](./docs/api_documentation.md) for more info

## Code quality

With `bundle exec rails code:analysis` you can run the code analysis tool, you can omit rules with:

- [Rubocop](https://github.com/bbatsov/rubocop/blob/master/config/default.yml) Edit `.rubocop.yml`
- [Reek](https://github.com/troessner/reek#configuration-file) Edit `config.reek`
- [Rails Best Practices](https://github.com/flyerhzm/rails_best_practices#custom-configuration) Edit `config/rails_best_practices.yml`
- [Brakeman](https://github.com/presidentbeef/brakeman) Run `brakeman -I` to generate `config/brakeman.ignore`

## Monitoring

In order to use [New Relic](https://newrelic.com) to monitor your application requests and metrics, you must setup `NEW_RELIC_API_KEY` and `NEW_RELIC_APP_NAME` environment variables.
To obtain an API key you must create an account in the platform.

## Configuring Code Climate

1. After adding the project to CC, go to `Repo Settings`
1. On the `Test Coverage` tab, copy the `Test Reporter ID`
1. Set the current value of `CC_TEST_REPORTER_ID` in the [GitHub secrets and variables](https://docs.github.com/en/actions/security-guides/using-secrets-in-github-actions#creating-secrets-for-a-repository)