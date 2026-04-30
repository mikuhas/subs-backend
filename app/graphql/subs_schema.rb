class SubsSchema < GraphQL::Schema
  mutation Types::MutationType
  query    Types::QueryType

  # N+1 対策（将来の dataloader 導入に備えて lazy 解決を有効化）
  use GraphQL::Dataloader
end
