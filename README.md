# Lavix

Dashboard financeiro moderno com tema dark e detalhes em laranja neon. Transforma dados em decisões rápidas por meio de categorias, lançamentos, gráficos e comparativos.

## Stack

- Ruby 3.2 · Rails 7.1
- PostgreSQL 16
- Tailwind CSS (tailwindcss-rails)
- Devise (autenticação)
- Chartkick + Groupdate (gráficos)
- Hotwire (Turbo + Stimulus) via Importmap
- Docker / Docker Compose

## Como subir o projeto

### 1. Com Docker (recomendado)

```bash
cp .env.example .env
docker compose build
docker compose up
```

Na primeira vez, o entrypoint já roda `db:prepare` (cria e migra o banco). Abra `http://localhost:3000`.

Para popular com dados de demonstração:
```bash
docker compose exec web bin/rails db:seed
```

Login demo criado pelo seed: **demo@lavix.app** / **lavix123**.

### 2. Localmente (sem Docker)

Pré-requisitos: Ruby 3.2.2, Postgres 16 rodando.

```bash
bundle install
bin/rails db:create db:migrate db:seed
bin/dev   # sobe Puma + watcher do Tailwind
```

## Estrutura

```
app/
├── controllers/   # Home, Dashboard, Categories, Transactions + Devise
├── models/        # User, Category, Transaction
├── views/
│   ├── dashboard/ # KPIs, gráficos, tabela comparativa
│   ├── categories/
│   ├── transactions/
│   └── devise/    # Login, cadastro, recuperar senha
├── assets/stylesheets/application.tailwind.css  # Paleta dark + laranja neon
└── javascript/    # Stimulus + Chartkick
config/
├── routes.rb
├── locales/pt-BR.yml
└── initializers/  # Devise, Chartkick
db/migrate/        # 3 migrations: users, categories, transactions
```

## Visualizando e-mails locais (Mailhog)

Em desenvolvimento, todos os e-mails enviados pelo Rails (ex: recuperação de senha do Devise) são interceptados pelo **Mailhog** — eles nunca saem para a internet.

Acesse a caixa de entrada local em: **`http://localhost:8025`**

O Mailhog sobe automaticamente com o `docker compose up`. Qualquer e-mail disparado pelo app aparece lá em tempo real, exatamente como o usuário receberia.

> Para e-mails chegarem de verdade em produção, configure um serviço SMTP real (ex: Resend, SendGrid) nas variáveis de ambiente.

## Visualizando usuários cadastrados

### Via Rails console
```bash
docker compose exec web rails console
```
```ruby
User.all                          # lista todos os usuários
User.count                        # total de usuários
User.pluck(:email, :created_at)   # e-mail e data de criação
User.find_by(email: "x@x.com")   # busca por e-mail
```

### Via psql (acesso direto ao banco)
```bash
docker compose exec db psql -U lavix -d lavix_development
```
```sql
SELECT id, email, created_at FROM users;
```
Sair com `\q`.

### Via cliente gráfico (TablePlus, DBeaver, etc.)
Conecte qualquer cliente PostgreSQL com as credenciais abaixo:

| Campo  | Valor               |
|--------|---------------------|
| Host   | `localhost`         |
| Porta  | `5432`              |
| Banco  | `lavix_development` |
| Usuário | `lavix`            |
| Senha  | `lavix`             |

> Os dados persistem no volume Docker `postgres_data` entre reinicializações. Só são apagados com `docker compose down -v`.

## Paleta visual

- **Fundo (ink-900)** `#0B0B0F`
- **Cards (ink-800)** `#18181B`
- **Bordas (ink-600)** `#27272A`
- **Texto (ink-50)** `#F4F4F5`
- **Neon (neon-500)** `#FF6B00`

Acentos neon aparecem em botões primários, cards de destaque (card-accent), links (link-neon) e badge de status.

## Modelos

- **User** (Devise) — `email`, `encrypted_password`
- **Category** — `name`, `color` (hex), pertence ao User. Cor é validada como `#RRGGBB`.
- **Transaction** — `amount`, `kind` (`income`/`expense`), `date`, `description`, pertence a User e Category.

Regras de negócio:
- Cada usuário só enxerga seus próprios dados (escopo por `current_user`).
- Categoria de um lançamento deve pertencer ao usuário dono.
- Categoria só é excluída se não tiver lançamentos (`restrict_with_error`).
