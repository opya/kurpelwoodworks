# frozen_string_literal: true

source "https://rubygems.org"

git_source(:github) {|repo_name| "https://github.com/#{repo_name}" }

gem "rake"
gem "puma"
gem "roda"
gem "roda-enhanced_logger"
gem "roda-route_list"
gem "sequel"
gem "sqlite3"
gem "mail"
gem "pagy"
gem "mina"
gem "i18n"
gem "dry-validation"
gem "dry-system"
gem "dotenv"

group :development do
  gem "letter_opener"
  gem "pry"
end

group :test do
  gem "rspec"
  gem "database_cleaner-sequel"
  gem "deep-cover"
end
