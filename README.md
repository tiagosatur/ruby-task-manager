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
brew services start posrgresql
```

- How to run the test suite

- Services (job queues, cache servers, search engines, etc.)

- Deployment instructions

- ...

## ✅ Objetivo do projeto

Uma API em Ruby on Rails 8 para gerenciar tarefas, com recursos como:

- CRUD completo de tarefas
- Filtros por status
- Ordenação por data
- Validações de dados

Testes com RSpec

## 📁 Estrutura do projeto

| Pasta              | Função                           |
| ------------------ | -------------------------------- |
| `app/models`       | Lógica de dados (modelo `Task`)  |
| `app/controllers`  | Ações da API (`TasksController`) |
| `config/routes.rb` | Rotas da API                     |
| `spec/`            | Testes com RSpec                 |

## 🛠️ Passo a passo para criar a API

✅ 1. Criar estrutura do Rails em modo API
Como já está dentro da pasta ruby-task-manager, rode:

```sh
rails new . --api -T
```

O -T pula a instalação do Minitest, pois usaremos o RSpec.

✅ 2. Adicionar gems de testes no Gemfile
No final do seu Gemfile, adicione:

```sh
group :development, :test do
  gem 'rspec-rails'
  gem 'factory_bot_rails'
  gem 'faker'
end
```

Depois rode:

```sh
bundle install
rails generate rspec:install
```

✅ 3. Gerar o model Task

```sh
rails g model Task title:string description:text status:string due_date:datetime
rails db:create db:migrate
```

✅ 4. Criar o controller da API

```sh
rails g controller api/v1/tasks --skip-template-engine --no-assets --no-helper
```

✅ 5. Configurar rotas
Em `config/routes.rb`, substitua tudo por:

```sh
Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :tasks
    end
  end
end

```
