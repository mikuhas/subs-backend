.PHONY: init build up up-d down restart logs console \
        db-create db-migrate db-rollback db-reset db-seed db-status \
        generate test lint secret

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
	@echo "💎 テスト・開発用Gemをインストール中..."
	docker-compose run --rm api bundle add rspec-rails factory_bot_rails faker --group development,test
	docker-compose run --rm api bundle exec rails generate rspec:install
	@echo "⚙️  Docker用設定ファイルを反映中..."
	docker-compose run --rm api bash -c "\
		cp .docker/database.yml config/database.yml && \
		cp .docker/cors.rb config/initializers/cors.rb && \
		cp .docker/seeds.rb db/seeds.rb"
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
test:
	docker-compose exec api bundle exec rspec

lint:
	docker-compose exec api bundle exec rubocop
