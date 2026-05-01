# AGENTS.md — バックエンド開発ガイド

## アーキテクチャ概要

本プロジェクトは **オニオンアーキテクチャ** を採用する。
外側のレイヤーは内側のレイヤーに依存できるが、内側は外側を知らない。

```
┌──────────────────────────────────────────┐
│  Interface（GraphQL Controller / Types）  │  ← 最外層
│  ┌────────────────────────────────────┐  │
│  │  Application（ユースケース）        │  │
│  │  ┌──────────────────────────────┐ │  │
│  │  │  Domain（ドメインサービス・   │ │  │
│  │  │  値オブジェクト）             │ │  │
│  │  └──────────────────────────────┘ │  │
│  └────────────────────────────────────┘  │
│  Infrastructure（AR モデル・リポジトリ）  │  ← 外側と同列（実装詳細）
└──────────────────────────────────────────┘
```

### 通信形式

**GraphQL**（`graphql` gem v2.3）を使用する。
エンドポイントは `POST /graphql` の一本のみ。

---

## ディレクトリ構成

```
app/
├── controllers/
│   ├── graphql_controller.rb    # [Interface層] GraphQL エンドポイント
│   └── api/v1/base_controller.rb
│
├── graphql/                     # [Interface層] GraphQL スキーマ定義
│   ├── subs_schema.rb           # スキーマルート
│   ├── types/                   # 出力型（シリアライザ相当）
│   │   ├── base_object.rb
│   │   ├── base_argument.rb
│   │   ├── base_field.rb
│   │   ├── base_mutation.rb
│   │   ├── base_input_object.rb
│   │   ├── query_type.rb        # Query ルート型（読み取り）
│   │   └── mutation_type.rb     # Mutation ルート型（書き込み）
│   └── mutations/               # Mutation 実装（コントローラ相当）
│       ├── users/
│       ├── communities/
│       ├── matching/
│       │   └── swipe_user.rb
│       └── messaging/
│
├── use_cases/                   # [Application層] ユースケース
│   ├── users/
│   ├── communities/
│   ├── matching/
│   │   └── swipe_user.rb
│   └── messaging/
│
├── domain/                      # [Domain層] ビジネスルール（外部依存ゼロ）
│   ├── services/
│   └── value_objects/
│
├── repositories/                # [Infrastructure層] データアクセス抽象化
│   ├── like_repository.rb
│   └── match_repository.rb
│
└── models/                      # [Infrastructure層] AR モデル（関連定義のみ）
    ├── user.rb
    ├── like.rb
    └── ...
```

---

## 各レイヤーの責務と禁止事項

### Domain 層 (`app/domain/`)

**責務**
- ビジネスルールと不変条件の定義
- 純粋 Ruby オブジェクト（ActiveRecord / Rails を `require` しない）
- ドメインサービス: 複数エンティティにまたがるロジック

**禁止**
- ActiveRecord の継承・使用
- HTTP / GraphQL の知識
- 外部 API 呼び出し

---

### Application 層 (`app/use_cases/`)

**責務**
- 1ユースケース = 1クラス（`call` メソッドを実装）
- リポジトリを DI してビジネスフローを実現
- トランザクション管理

**禁止**
- `context` / `params` を直接受け取る（Mutation が整形して渡す）
- JSON / GraphQL の知識
- ActiveRecord を直接クエリする（必ずリポジトリ経由）

```ruby
# 良い例: app/use_cases/matching/swipe_user.rb
module UseCases
  module Matching
    class SwipeUser
      def initialize(like_repo: LikeRepository.new, match_repo: MatchRepository.new)
        @like_repo  = like_repo
        @match_repo = match_repo
      end

      def call(from_user_id:, to_user_id:, action:)
        like = @like_repo.create!(from_user_id:, to_user_id:, action:)

        matched = false
        if action == 'like' && @like_repo.mutual_like_exists?(from_user_id:, to_user_id:)
          u1, u2 = [from_user_id, to_user_id].minmax
          @match_repo.find_or_create!(user1_id: u1, user2_id: u2)
          matched = true
        end

        { like:, matched: }
      end
    end
  end
end
```

---

### Infrastructure 層 (`app/models/`, `app/repositories/`)

**`app/models/` の責務**
- AR の関連定義（`has_many`, `belongs_to`）
- DB レベルのバリデーション（最小限）
- コールバックは **禁止**（ビジネスロジックを Use Case / Domain に移す）

**`app/repositories/` の責務**
- AR を wrap してデータアクセスを抽象化
- Use Case の DI で差し替え可能にする（テスト容易性）

```ruby
# 良い例: app/repositories/like_repository.rb
class LikeRepository
  def create!(from_user_id:, to_user_id:, action:)
    Like.create!(from_user_id:, to_user_id:, action:)
  end

  def mutual_like_exists?(from_user_id:, to_user_id:)
    Like.exists?(from_user_id: to_user_id, to_user_id: from_user_id, action: 'like')
  end
end
```

---

### Interface 層 (`app/graphql/`, `app/controllers/`)

**GraphQL Controller の責務**
- `POST /graphql` を受け付けて `SubsSchema.execute` に委譲
- `context[:current_user]` への認証済みユーザーのセット
- エラー形式の正規化（development のみスタックトレースを返す）

**Types の責務（シリアライザ相当）**
- AR オブジェクトを GraphQL フィールドに変換
- `field` の定義のみ。ビジネスロジックを持たない

**Mutations の責務（コントローラ相当）**
- 引数を受け取り Use Case を呼び出す
- 成功・失敗を GraphQL ペイロードとして返す

```ruby
# 良い例: app/graphql/mutations/matching/swipe_user.rb
module Mutations
  module Matching
    class SwipeUser < Types::BaseMutation
      argument :to_user_id, ID,     required: true
      argument :action,     String, required: true   # 'like' | 'skip'

      field :matched, Boolean, null: false
      field :errors,  [String], null: false

      def resolve(to_user_id:, action:)
        result = UseCases::Matching::SwipeUser.new.call(
          from_user_id: context[:current_user].id,
          to_user_id:   to_user_id.to_i,
          action:,
        )
        { matched: result[:matched], errors: [] }
      rescue ActiveRecord::RecordInvalid => e
        { matched: false, errors: e.record.errors.full_messages }
      end
    end
  end
end
```

---

## 新機能の追加手順

1. **マイグレーション作成** — `db/migrate/`
2. **AR モデル追加** — `app/models/`（関連定義・最小限のバリデーションのみ）
3. **リポジトリ追加** — `app/repositories/`
4. **ドメインサービス追加**（必要な場合）— `app/domain/services/`
5. **ユースケース追加** — `app/use_cases/<bounded_context>/`
6. **GraphQL Type 追加** — `app/graphql/types/`（出力型）
7. **GraphQL Mutation / Query 追加** — `app/graphql/mutations/` or `types/query_type.rb`
8. **MutationType / QueryType に登録** — `app/graphql/types/mutation_type.rb`

---

## 認証

### 方式

JWT（Bearer トークン）。有効期限 30 日。トークンは `signIn` / `signUp` の返却値から取得する。

```
Authorization: Bearer <token>
```

### フロー

```
クライアント                     GraphqlController        SubsSchema
    |                                   |                      |
    |-- POST /graphql (signUp/signIn) ->|                      |
    |                                   |-- execute ---------->|
    |                                   |            (current_user: nil)
    |<-- { token, user } -------------- |                      |
    |                                   |                      |
    |-- POST /graphql (認証必要 Mutation)|                      |
    |  Authorization: Bearer <token>    |                      |
    |                                   |-- current_user() --->|
    |                                   |   JWT.decode(token)  |
    |                                   |-- execute ---------->|
    |                                   |   (current_user: User)
```

### 実装場所

| 役割 | ファイル |
|---|---|
| JWT encode / decode | `app/lib/json_web_token.rb` |
| トークン発行 | `UseCases::Users::SignUp` / `SignIn` |
| トークン検証・current_user セット | `GraphqlController#current_user` |
| 認証ガード | `Types::BaseMutation#authenticate!` |

### 認証が必要な Mutation の書き方

```ruby
def resolve(...)
  authenticate!   # ← 先頭で呼ぶ。未認証なら GraphQL::ExecutionError を raise
  # ...
end
```

`signUp` / `signIn` では `authenticate!` を呼ばない。

### エラー設計

- **認証失敗**（トークン無し・期限切れ）→ `GraphQL::ExecutionError` として top-level `errors` に返す
- **バリデーションエラー**（メール重複等）→ `errors: [String]` フィールドで返す
- **パスワード不一致**（SignIn）→ `UseCases::Users::SignIn::AuthenticationError` → `errors` フィールドで返す

---

## GraphQL 運用規則

### エラー設計

GraphQL ではエラーを **2パターン** で使い分ける。

| ケース | 方法 |
|---|---|
| ユーザーに見せるバリデーションエラー | `errors: [String]` フィールドで返す |
| 予期しないサーバーエラー | `raise` して GraphQL の top-level errors に乗せる |

### Mutation の返却型

すべての Mutation は `errors: [String]` フィールドを持つ。
クライアントは `errors` が空かどうかで成否を判断する。

```graphql
mutation {
  swipeUser(input: { toUserId: "42", action: "like" }) {
    matched
    errors
  }
}
```

### N+1 対策

`app/graphql/subs_schema.rb` で `GraphQL::Dataloader` を有効化済み。
リレーションをループで解決する場合は `dataloader` の `Source` を使う。

---

## セットアップコマンド

```bash
# バックエンド（backend/ ディレクトリ）
make init          # 初回セットアップ（rails new + DB作成）
make up            # コンテナ起動
make db-migrate    # マイグレーション実行
make console       # Rails コンソール
make test          # RSpec 実行

# フロントエンド（subs/ ルートで実行、または backend/ から make で）
make frontend-install  # npm install
make frontend-dev      # npm run dev (port 5173)
```

---

## Claude実行用コマンド

コード把握・トークン削減のために用意したコマンド。

### ファイル構成確認（ローカル実行可能）

```bash
make ls-all        # 全レイヤーのファイル一覧を一括表示
make ls-models     # app/models/ 一覧
make ls-repos      # app/repositories/ 一覧
make ls-usecases   # app/use_cases/ 一覧
make ls-types      # app/graphql/types/ 一覧
make ls-mutations  # app/graphql/mutations/ 一覧
make db-schema     # db/schema.rb を表示（migrate 後に生成）
```

### スキーマ確認（Docker 起動が必要）

```bash
make routes           # Rails ルート一覧
make graphql-schema   # GraphQL SDL 全体を出力（SubsSchema.to_definition）
```

### 使い方の指針

| 知りたいこと | 使うコマンド |
|---|---|
| どんなモデルがあるか | `make ls-models` |
| ユースケースの一覧 | `make ls-usecases` |
| Mutation の一覧 | `make ls-mutations` |
| DB のカラム構成 | `make db-schema` |
| GraphQL の全型定義 | `make graphql-schema` |
| フロントエンドのコンテキスト・lib 一覧 | `make ls-frontend` |

---

## フロントエンド接続

### 構成

```
subs/ (フロントエンド)
├── .env                         # VITE_GRAPHQL_ENDPOINT=http://localhost:3000/graphql
├── src/
│   ├── env.d.ts                 # Vite 環境変数の型定義
│   ├── lib/
│   │   ├── apolloClient.ts      # Apollo Client（Authorization ヘッダー自動付与）
│   │   └── graphql/
│   │       └── operations.ts   # 全 Query / Mutation の gql 定義
│   ├── contexts/
│   │   ├── AuthContext.tsx      # signIn → JWT → localStorage 管理
│   │   ├── CommunityContext.tsx # communities query + join/leave mutation
│   │   └── MessageContext.tsx  # sendMessage mutation（楽観的 UI）
│   └── composables/
│       └── useMatchingApp.ts   # candidates query + swipeUser mutation
```

### トークン管理

| キー | 内容 |
|---|---|
| `localStorage.auth_token` | JWT トークン（30日有効） |
| `localStorage.auth_email` | ログイン時のメール（profile 復元用） |

### API 接続フロー

1. `main.tsx` → `<ApolloProvider>` が最外層
2. リクエスト時 `authLink` が `Authorization: Bearer <token>` を自動付与
3. 認証エラー（401）は GraphQL `errors` フィールドに返る
4. ページリロード時: `AuthContext` が localStorage のトークンで `me` クエリを実行しセッション復元

### フロントエンドから API を呼ぶ実装パターン

```typescript
// Query（読み取り）
const { data, loading } = useQuery(CANDIDATES, { skip: !isLoggedIn })

// Mutation（書き込み）
const [swipeUser] = useMutation(SWIPE_USER)
await swipeUser({ variables: { toUserId: '42', action: 'like' } })
```

### 既存モックとの共存

| 機能 | 状態 |
|---|---|
| ログイン / ログアウト | ✅ 実 API |
| コミュニティ一覧・参加・脱退 | ✅ 実 API |
| スワイプ候補一覧・スワイプ | ✅ 実 API |
| メッセージ送信 | ✅ 実 API（表示は楽観的ローカル UI） |
| いいね済み・スキップ済みリスト | ローカル state（ページリロードでリセット） |
| 受けたいいね一覧 | 未実装（空配列） |

---

## 境界コンテキスト（Bounded Context）

| コンテキスト | Query | Mutation | 状態 |
|---|---|---|---|
| `users` | `me` | `signUp`, `signIn`, `updateProfile` | ✅ 実装済 |
| `communities` | `communities` | `joinCommunity`, `leaveCommunity` | ✅ 実装済 |
| `matching` | `candidates`, `matches` | `swipeUser` | ✅ 実装済 |
| `messaging` | `messages(partnerId)` | `sendMessage` | ✅ 実装済 |

---

## 既存コードのリファクタリング方針

| 現状 | 移行先 | 状態 |
|---|---|---|
| `Like#check_mutual_like`（コールバック） | `UseCases::Matching::SwipeUser` | ✅ 完了 |
| `User#as_match_json` | `Types::UserType` の field 定義 | ✅ 完了 |
| `Message#as_api_json` | `Types::MessageType` の field 定義 | ✅ 完了 |
| `Community#as_api_json` | `Types::CommunityType` の field 定義 | ✅ 完了 |

## Claude Codeへ指示
 - 基本的にコメントは不要です。人間が読み取ることが難しそうな箇所のみコメントを付けてください。(※関数ごとのDOCはつけてください。実行内容の要約、引数、戻り値はつけてください)
 - 1つの関数の最大行は最大50行にしてください。それ以上になりそうであれば分割してください。
 - ローカルで実行した際に人間がlogを追うことができるようにしてください。