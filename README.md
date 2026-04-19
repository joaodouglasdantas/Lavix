# Lavix

Dashboard financeiro moderno que transforma dados em decisões rápidas. Interface escura com detalhes em laranja neon, construída com Ruby on Rails 7, PostgreSQL e Tailwind CSS.

---

## Stack

| Camada | Tecnologia |
|---|---|
| Backend | Ruby 3.2.2 + Rails 7.1 |
| Banco de dados | PostgreSQL 16 |
| Frontend | Tailwind CSS + Stimulus + Turbo |
| Asset pipeline | Propshaft + Importmap |
| Autenticação | Devise |
| Gráficos | Chartkick + Groupdate |
| Containerização | Docker + Docker Compose |
| Deploy | Railway |

---

## Rodando localmente

### Pré-requisitos

- [Docker Desktop](https://www.docker.com/products/docker-desktop/) instalado e rodando

### Subir o ambiente

```bash
docker compose up --build
```

Isso sobe quatro serviços:

| Serviço | O que faz | Endereço |
|---|---|---|
| `web` | Servidor Rails | http://localhost:3000 |
| `db` | PostgreSQL | localhost:**5433** |
| `css` | Watcher do Tailwind | — |
| `mailhog` | Caixa de emails local | http://localhost:8025 |

Na primeira vez, crie o banco e rode as migrations:

```bash
docker compose exec web bin/rails db:create db:migrate
```

Para popular com dados de demonstração:

```bash
docker compose exec web bin/rails db:seed
```

Login demo criado pelo seed: **demo@lavix.app** / **lavix123**

### Parar o ambiente

```bash
docker compose down        # para os containers
docker compose down -v     # para e apaga todos os dados do banco
```

---

## Acessar o banco de dados

### Via pgAdmin ou qualquer cliente gráfico

O PostgreSQL local roda na porta **5433** — não 5432, para evitar conflito com instalações locais do Postgres.

| Campo | Valor |
|---|---|
| Host | `localhost` |
| Porta | `5433` |
| Banco | `lavix_development` |
| Usuário | `lavix` |
| Senha | `lavix` |

> Se o pgAdmin pedir o tipo de autenticação, selecione **Senha (Password)**.

### Via Rails console

```bash
docker compose exec web rails console
```

```ruby
User.all                          # lista todos os usuários
User.count                        # total de usuários
User.pluck(:email, :created_at)   # e-mail e data de criação
User.find_by(email: "x@x.com")   # busca por e-mail
Category.all                      # todas as categorias
Transaction.where(kind: "expense").sum(:amount)  # total de despesas
```

### Via psql (terminal direto no banco)

```bash
docker compose exec db psql -U lavix -d lavix_development
```

```sql
SELECT id, email, created_at FROM users;
SELECT * FROM categories;
SELECT * FROM transactions ORDER BY date DESC LIMIT 10;
```

Sair com `\q`.

> Os dados persistem no volume Docker `postgres_data` entre reinicializações. Só são apagados com `docker compose down -v`.

---

## Ver emails locais (MailHog)

Em desenvolvimento, todos os emails enviados pelo Rails (confirmação de conta, recuperação de senha etc.) são interceptados pelo **MailHog** — nenhum email real é enviado.

Acesse: **http://localhost:8025**

O MailHog sobe automaticamente com o `docker compose up`. Qualquer email disparado pelo app aparece lá em tempo real.

---

## Comandos úteis

```bash
# Rodar migrations
docker compose exec web bin/rails db:migrate

# Abrir console Rails
docker compose exec web bin/rails console

# Ver logs em tempo real
docker compose logs -f web

# Rebuild da imagem (após mudanças no Dockerfile ou Gemfile)
docker compose up --build

# Acessar o shell do container
docker compose exec web bash
```

---

## Estrutura do projeto

```
app/
├── controllers/   # Home, Dashboard, Categories, Transactions + Devise
├── models/        # User, Category, Transaction
├── views/
│   ├── dashboard/     # KPIs, gráficos, tabela comparativa
│   ├── categories/
│   ├── transactions/
│   └── shared/        # Navbar, flash messages
├── assets/
│   └── stylesheets/application.tailwind.css  # Paleta dark + laranja neon
└── javascript/    # Stimulus controllers (color picker, etc.)
config/
├── routes.rb
├── tailwind.config.js
├── locales/pt-BR.yml
└── environments/  # development, production
db/migrate/        # 3 migrations: users, categories, transactions
```

---

## Rotas principais

| Rota | Descrição |
|---|---|
| `/` | Landing pública |
| `/dashboard` | Dashboard (requer login) |
| `/categories` | CRUD de categorias |
| `/transactions` | CRUD de lançamentos |
| `/users/sign_in` | Login |
| `/users/sign_up` | Cadastro |
| `/users/password/new` | Recuperar senha |
| `/up` | Health check |

---

## Modelos

**User** (Devise) — `email`, `encrypted_password`

**Category** — `name`, `color` (hex `#RRGGBB`), pertence ao User

**Transaction** — `amount`, `kind` (`income`/`expense`), `date`, `description`, pertence a User e Category

Regras de negócio:
- Cada usuário enxerga apenas seus próprios dados (escopo por `current_user`)
- Categoria de um lançamento deve pertencer ao mesmo usuário
- Categoria só pode ser excluída se não tiver lançamentos (`restrict_with_error`)

---

## Deploy (Railway)

O projeto está deployado no [Railway](https://railway.app) com PostgreSQL gerenciado.

### Variáveis de ambiente necessárias

| Variável | Descrição |
|---|---|
| `RAILS_ENV` | `production` |
| `SECRET_KEY_BASE` | Chave secreta longa e aleatória |
| `DATABASE_URL` | Injetada automaticamente pelo addon PostgreSQL do Railway |

---

## Paleta visual

| Token | Hex | Uso |
|---|---|---|
| `ink-900` | `#0B0B0F` | Fundo da página |
| `ink-800` | `#18181B` | Cards |
| `ink-600` | `#27272A` | Bordas |
| `ink-50` | `#F4F4F5` | Texto principal |
| `neon-500` | `#FF6B00` | Laranja neon — botões, destaques, links |

Acentos neon aparecem em botões primários, cards de destaque (`card-accent`), links (`link-neon`) e badges de status.


---

[![Built with Claude](https://img.shields.io/badge/Built%20with-Claude-FF6B00?style=flat)](https://claude.ai)

---

## Observações técnicas

**Tailwind no Windows/WSL2 com Docker**
O serviço `css` usa `--poll` para o file watching funcionar no Docker em Windows, onde o inotify não funciona. É a solução oficial documentada para esse ambiente.

**Porta do PostgreSQL**
A porta local é `5433` em vez de `5432` para não conflitar com instalações locais do Postgres. Dentro da rede Docker, os serviços se comunicam normalmente na `5432`.

**Assets em produção**
O Tailwind é compilado durante o build da imagem Docker com saída em `app/assets/builds/application.css`. O Propshaft varre os assets para `public/assets/` com fingerprints para cache busting.
