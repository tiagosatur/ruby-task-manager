# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

- Ruby version
  3.3.5

- System dependencies

- Configuration

- Database creation

```sh
brew install postgresql
rails db:create db:migrate
```

- Database initialization

```sh
brew services start postgresql
```

- How to run the test suite

- Services (job queues, cache servers, search engines, etc.)

- Deployment instructions

- ...

## ✅ Project Objective

A Ruby on Rails 8 API for managing tasks, with features like:

- Complete CRUD operations for tasks
- Filtering by status
- Sorting by date
- Data validation

Testing with RSpec

## 📁 Project Structure

| Folder             | Function                        |
| ------------------ | ------------------------------- |
| `app/models`       | Data logic (`Task` model)       |
| `app/controllers`  | API actions (`TasksController`) |
| `config/routes.rb` | API routes                      |
| `spec/`            | Tests with RSpec                |

## 🛠️ Step-by-step guide to create the API

✅ 1. Create Rails structure in API mode
Since you're already inside the ruby-task-manager folder, run:

```sh
rails new . --api -T
```

The -T flag skips Minitest installation, as we'll use RSpec.

✅ 2. Add testing gems to Gemfile
At the end of your Gemfile, add:

```sh
group :development, :test do
  gem 'rspec-rails'
  gem 'factory_bot_rails'
  gem 'faker'
end
```

Then run:

```sh
bundle install
rails generate rspec:install
```

✅ 3. Generate the Task model

```sh
rails g model Task title:string description:text status:string due_date:datetime
rails db:create db:migrate
```

✅ 4. Create the API controller

```sh
rails g controller api/v1/tasks --skip-template-engine --no-assets --no-helper
```

✅ 5. Configure routes
In `config/routes.rb`, replace everything with:

```sh
Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :tasks
    end
  end
end

```
