MYSQL_ROOT_PASSWORD := $(shell grep "^MYSQL_ROOT_PASSWORD=" .env | cut -d= -f2)

.PHONY: init build up up-d down restart logs console \
        db-create db-migrate db-rollback db-reset db-seed db-status \
        generate test test-db-setup lint secret

# ═══════════════════════════════════════════════════
#  初回セットアップ（一度だけ実行）
# ═══════════════════════════════════════════════════
init:
	@echo "🔨 Dockerイメージをビルド中..."
	docker-compose build
	@echo "🚂 Railsアプリを生成中 (rails new)..."
	docker-compose run --rm api rails new . --api --database=mysql --skip-git --force
	@echo "💎 追加Gemをインストール中..."
	docker-compose run --rm api bundle add rack-cors dotenv-rails
	docker-compose run --rm api bundle add graphql --version "~> 2.3"
	docker-compose run --rm api bundle add jwt     --version "~> 2.9"
	@echo "💎 テスト・開発用Gemをインストール中..."
	docker-compose run --rm api bundle add rspec-rails factory_bot_rails faker --group development,test
	docker-compose run --rm api bundle exec rails generate rspec:install
	@echo "⚙️  Docker用設定ファイルを反映中..."
	docker-compose run --rm api bash -c "\
		cp .docker/database.yml config/database.yml && \
		cp .docker/cors.rb config/initializers/cors.rb && \
		cp .docker/seeds.rb db/seeds.rb && \
		cp .docker/routes.rb config/routes.rb"
	@echo "🗄️  DBを起動してデータベースを作成中..."
	docker-compose up -d db
	@echo "⏳ MySQL起動待ち..."
	docker-compose run --rm api bash -c "until mysqladmin ping -h db -u$$DATABASE_USER -p$$DATABASE_PASSWORD --silent; do sleep 2; done"
	docker-compose run --rm api bundle exec rails db:create
	docker-compose down
	@echo ""
	@echo "✅ セットアップ完了！"
	@echo "   次のコマンドで起動: make up"
	@echo "   SECRET_KEY_BASE は .env に設定してください: make secret"

# ═══════════════════════════════════════════════════
#  日常操作
# ═══════════════════════════════════════════════════
build:
	docker-compose build

up:
	docker-compose up

up-d:
	docker-compose up -d

down:
	docker-compose down

restart:
	docker-compose restart api

logs:
	docker-compose logs -f api

# ═══════════════════════════════════════════════════
#  Rails操作
# ═══════════════════════════════════════════════════
console:
	docker-compose exec api bundle exec rails console

# 例: make generate ARGS="model User name:string"
generate:
	docker-compose exec api bundle exec rails generate $(ARGS)

routes:
	docker-compose exec api bundle exec rails routes

secret:
	@echo "以下の値を .env の SECRET_KEY_BASE に設定してください:"
	@docker-compose run --rm api bundle exec rails secret

# ═══════════════════════════════════════════════════
#  DB操作
# ═══════════════════════════════════════════════════
db-create:
	docker-compose exec api bundle exec rails db:create

db-migrate:
	docker-compose exec api bundle exec rails db:migrate

db-rollback:
	docker-compose exec api bundle exec rails db:rollback

db-reset:
	docker-compose exec api bundle exec rails db:reset

db-seed:
	docker-compose exec api bundle exec rails db:seed

db-setup:
	docker-compose exec api bundle exec rails db:create db:migrate db:seed

db-status:
	docker-compose exec api bundle exec rails db:migrate:status

# ═══════════════════════════════════════════════════
#  テスト・品質管理
# ═══════════════════════════════════════════════════
test-db-setup:
	docker-compose exec -T db mysql -uroot -p$(MYSQL_ROOT_PASSWORD) -e "CREATE DATABASE IF NOT EXISTS \`subs_test\`; GRANT ALL PRIVILEGES ON \`subs_test\`.* TO 'subs_user'@'%'; FLUSH PRIVILEGES;"
	docker-compose exec api bundle exec rails db:migrate RAILS_ENV=test

test:
	docker-compose exec api bundle exec rspec

lint:
	docker-compose exec api bundle exec rubocop

# ═══════════════════════════════════════════════════
#  フロントエンド操作（subs/ ルートで実行）
# ═══════════════════════════════════════════════════
frontend-install:
	cd .. && npm install

frontend-dev:
	cd .. && npm run dev

# フロントエンドのファイル構成確認（ローカル実行可）
ls-frontend:
	@echo "=== src/contexts ===" && find ../src/contexts -name "*.tsx" | sort
	@echo "=== src/lib ===" && find ../src/lib -name "*.ts" | sort
	@echo "=== src/composables ===" && find ../src/composables -name "*.ts" | sort

# ═══════════════════════════════════════════════════
#  Claude実行用コマンド（コード把握・トークン削減）
# ═══════════════════════════════════════════════════

# ファイル構成の把握（ローカル実行可）
ls-models:
	@find app/models -name "*.rb" | sort

ls-repos:
	@find app/repositories -name "*.rb" | sort

ls-usecases:
	@find app/use_cases -name "*.rb" | sort

ls-mutations:
	@find app/graphql/mutations -name "*.rb" | sort

ls-types:
	@find app/graphql/types -name "*.rb" | sort

ls-all:
	@echo "=== models ===" && find app/models -name "*.rb" | sort
	@echo "=== repositories ===" && find app/repositories -name "*.rb" | sort
	@echo "=== use_cases ===" && find app/use_cases -name "*.rb" | sort
	@echo "=== graphql/types ===" && find app/graphql/types -name "*.rb" | sort
	@echo "=== graphql/mutations ===" && find app/graphql/mutations -name "*.rb" | sort

# DB スキーマ確認（ローカル実行可・migrate 後に生成される）
db-schema:
	@cat db/schema.rb 2>/dev/null || echo "schema.rb が見つかりません。make db-migrate を実行してください"

# GraphQL スキーマ確認（Docker 起動が必要）
graphql-schema:
	docker-compose exec api bundle exec rails runner "puts SubsSchema.to_definition"
