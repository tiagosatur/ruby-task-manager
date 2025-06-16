#📌 Suas dúvidas respondidas

## Dúvidas gerais

### O que é bundle install?

Esse comando lê o `Gemfile` (onde ficam listadas as gems do projeto) e instala todas as dependencias que estão ali, baixando-as para o ambiente atual da versão do Ruby.

- Ele tambem gera o `Gemfile.lock`, que trava as versões gas gems instaladas, garantindo reprodutibilidade.

### Por que adicionamos essas gems?

```sh
gem 'rspec-rails          # Testes com RSpec, o padrão de fato em Rails apps maduros'
gem 'factory_bot_rails'   # Criação de "fábricas" para criar objetos de teste (FactoryBot.create(:task))
gem 'faker'               # Geração de dados fake (nomes, emails, etc.)
```

### Quais os métodos padrão do Rails (CRUD)? Eles são:

- index - lista todos os registros
- show - mostra um registro específico
- new - formulário para criar novo registro (GET)
- create - salva um novo registro (POST)
- edit - busca o registro para poder atualizar (GET)
- update - atualiza um registro (PATCH/PUT)
- destroy - remove um registro

### Por que `TaskController` veio com esse código?

```ruby
class Api::V1::TasksController < ApplicationController
end
```

Isso é o basico que o gerador cria automaticamente. O Rails já entende a estrutura de nomes em namespaces (pastas aninhadas como api/v1), e cria class com a hierarquia correta. O restante (métodos `index`, `create`, etc.) é por nossa conta.

### `class TasksController < ApplicationController`

Significa:

- `TasksController`éw a classe do seu controller de tarefas.
- `< ApplicationController` indica que essa classe herda de `ApplicationController`
  Isso dá acesso a métodos como `render`, `params`, `head`, etc, que vem do rails.

### `before_action :set_task, only: [:show, :update, :destroy]

Esse é um filtro que o Rails executa antes de certos métodos do controller.

- `:set_task`é o nome de um método privado
- `only: [...]` define em quais actions ele roda
- Então, antes de `show`, `update` ou `destroy`, ele executa `set_task`

Por quê?
Porque esses métodos precisam encontrar a tarefa no banco de dados. Isso evita repetir `@task = Task.find(...)` em cada um deles.

### Como o model `Task` é automaticamente disponibilizado no controller?

No Rails qualquer model é automaticamente disponibilizado no controller por causa do `autoloading` e da convenção sobre configuração do framework.

**Como funciona?**

1. Convençao de nomes

- O arquivo do model deve estar em `app/models/task.rb`
- A classe deve se chamar `Task`
- O Rails carrega automaticamente todas as classes de model que estão em `app/models`

2. Autoloading (Zeitwerk)

- O Rails usa um sistema chamado Zeitwerk para carregar as classes automaticamente quando você as referencia pela primeira vez.

3. Herança de ActiveRecord

- O model `Task` normalmente herda de `ApplicationRecord`, que por sua vez herda de `ActiveRecord::Base`.
- Isso faz com que todos os métodos do ActiveRecord (como `.all`, `.find`, `.where`) estejam disponíveis para `Task`.

### Qual banco de dados o rails usa?

Por padrão, o Rails usa `SQLite`como banco de dados no ambiente de desenvolvimento.

#### Como funciona o banco de dados no Rails?

1. **Banco padrão: SQLite**

- Qaundo voce cria um novo projeto Rails, ele já configura o SQLite automaticamente.
- O arquivo do banco fica em `db/development.sqlite3`.
- O SQLite é um banco de dados leve, baseado em arquivo, ótimo para desenvolvimento e testes locais.

2. **Configuração automática**

- O Rails gera o `config/database.yml` com as configurações para cada ambiente (dev, prod e test).
- No development, o padrão é:

```yaml
develpment:
  adapter: sqlite3
  database: db/development.sqlite3
```

- Por isso voce não precisa configurar nada para começar a usar.

3. **Outros bancos suportados**

- Em produção, é comum usar bancos como **PostgreSQL** ou **MYSQL**
- Para trocar de banco, basta editar o `database.yml`, e instalar o adaptador correspondente (gem)

4. **Migrações**

- O Rails usa migrações para criar e modificar tabelas no banco de dados.
- Voce cria arquivos de migrações e executa com `rails db:migrate`

### Como usar dois pontos (`:`) em ruby?

1. **Símbolos**

- Os dois pontos vem ANTES do nome `:nome`
- Símbolos são objetos imutáveis sendo usados como identificadores, chaves de hash, etc.

```ruby
:title
:user
:not_found
```

- Usados em:
  - Chaves de hashes (Ruby antigo): `{ :title => "Exemplo" }`
  - Parâmetros de métodos
  - Identificadores em geral

2. **Hash com sintaxe de keyword (chave: valor)**

- Os dois pontos vem DEPOIS do nome da chave: `chave: valor`
- É uma sintaxe mais moterna para hashes, parecida com JSON:

```ruby
{ title: "Exemplo", user: "Jhon", status: :not_found }
```

## Como mudar nosso banco para postgres?

1. **Adicione a gem do PostgreSQL**

   No seu Gemfile, substitua o `sqlite3` pelo `pg`:

   ```ruby
   gem 'pg'
   ```

   Depois rode:

   ```sh
   bundle install
   ```

2. **Ajuste o arquivo de configuração do banco e altera a configuração para usar PostgreSQL**:

No `config/database.yml`:

```sh
default: &default
  adapter: postgresql
  encoding: unicode
  username: <%= ENV["PGUSER"] %>
  password: <%= ENV["PGPASSWORD"] %>
  host: <%= ENV["PGHOST"] %>
  pool: 5

development:
  <<: *default
  database: ruby_task_manager_development

test:
  <<: *default
  database: ruby_task_manager_test

production:
  <<: *default
  database: ruby_task_manager_production
  username: <%= ENV["PGUSER"] %>
  password: <%= ENV["PGPASSWORD"] %>
  host: <%= ENV["PGHOST"] %>
```

Ajuste `username`, `password` e host conforme seu ambiente.

3.** Instale o PostgreSQL localmente (se ainda não tiver)**

No Mac, você pode usar:

Verifique se já possui com:

```sh
psql --version
```

Caso nao tenha instale:

```sh
brew install postgresql
brew services start postgresql
```

4. **Crie os bancos de dados**

   ```sh
   rails db:create db:migrate
   ```

5. (Opcional) Ajuste o Docker/Docker Compose
   Se for usar Docker, adicione um serviço para o banco no seu docker-compose.yml:

```yaml
services:
  db:
    image: postgres:15
    environment:
      POSTGRES_PASSWORD: password
      POSTGRES_USER: postgres
      POSTGRES_DB: ruby_task_manager_development
    ports:
      - "5432:5432"
```

E ajuste o database.yml para apontar para o serviço db como host.

6. Remova o arquivo antigo do SQLite

```sh
rm db/development.sqlite3
```

## Método `list`

```ruby
def list
  tasks = Task.all.order(due_date: :asc)
  render json: tasks
end
```

- `tasks` é uma variavel local do método list, se fosse `@tasks`, existiria em todo o controller no momento da requisição (bastante usada para quando se precisa renderizar uma view (html)).
- Além do `order`, existem outros métodos como:
  - `Task.where(status: "done")` - filtra todos os registros com base em condições;
  - `Task.find(1)` que busca um registro pelo ID;
  - `Task.find_by(title: "Comprar PS5")` - busca o primeiro registro que bate com a condição;
  - `Task.first` ou `Task.last` - retorna primeiro ou último registro;
  - `Task.limit` - limita a quantidade de itens retornados;
  - `Task.offset(10)` - Pula uma quantidade de registros antes de começar a retornar;
  - `Task.pluck(:title)` - retorna apenas os valores de uma ou mais colunas;
  - `Task.select(:id, :title)` - permite escolher quais colunas trazer (obs: nao entendi qual a diferença de .pluck);
  - `Task.group(:status).count` - agrupa registros por um campo;
  - `Task.joins(:user)` - Faz junção com outras tabelas
  - `Task.includes(:user)` - carrega associações para evitar N+1 queries;
  - `Task.select(:status).distinct` - retorna apenas valores distintos;
  - `Task.count / Task.sum(:points) / Task.average(:points)` - métodos de agregação;
  - `Task.select(status: "done").destroy_all` - apaga todos os registros encontrados

### Quando que o `def index` é chamado e pra que serve?

O método `index`, que lista todos os registros, é chamado quando se faz uma requisição GET pra rota.

### `render json: tasks` ta fazendo o que?

1. render - é um método do Rails que envia uma resposta HTTP
2. json: - indica que a resposta será no formato JSON
3. tasks - é o objeto que será convertido em JSON

### Posso mudar o nome do método `index` pra `list`?

Sim mas isso requer duas alterações:

1. Mudar o nome do método no controller
2. Atualizar a rota para apontar para o novo nome:

```ruby
namespace :api do
  namespace :v1 do
    resources :tasks, only: [:show, :create, :update, :destroy] do
      collection do
        get :list
      end
    end
  end
end
```

## `set_task`

O que é e de onde vem `params`? o params é um objeto especial (um hash) que contém **todos os parametros enviados na requisição HTTTP**. Ele está disponível automaticamente em todos os controllers e actions.

### De onde vem o `params`?

- O rails cria o objeto `params`para cada requisição recebida.
- Ele junta:
  - Parametros de rota (ex: `/tasks/1` => `params[:id] === 1`)
  - Parametros de query string (ex: `/tasks?status=done` => `params[:status] == "done`)
  - Parametros de formulário (ex: enviados via POST)
  - Parametros de JSON (em APIs)
