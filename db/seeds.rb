# frozen_string_literal: true
# db/seeds.rb — モックデータをDBに投入

puts "🌱 Seeding communities..."

communities_data = [
  { name: 'カフェ部',          tag: 'カフェ・グルメ', description: '都内のカフェを一緒に巡ろう！おすすめ情報を共有しましょう。',         icon_class: 'ri-cup-line',           member_count: 342 },
  { name: '音楽好き集まれ',     tag: '音楽',         description: 'ライブ・コンサート情報を共有。一緒に行く仲間を見つけよう。',           icon_class: 'ri-music-line',          member_count: 218 },
  { name: '旅行仲間',          tag: '旅行',         description: '国内外の旅行好き集まれ！旅の計画を一緒に立てよう。',                   icon_class: 'ri-plane-line',          member_count: 456 },
  { name: 'アウトドア部',       tag: 'アウトドア',   description: 'ハイキング・キャンプが好きな人で集まろう。',                           icon_class: 'ri-tent-line',           member_count: 183 },
  { name: 'グルメ探検隊',       tag: 'カフェ・グルメ', description: '東京の美味しいお店を一緒に探索しよう。',                           icon_class: 'ri-restaurant-2-line',   member_count: 521 },
  { name: '読書 Salon',         tag: '読書',         description: '本の感想を語り合ったり、読書会を開こう。',                           icon_class: 'ri-book-open-line',      member_count: 167 },
  { name: 'スポーツ好き',       tag: 'スポーツ',     description: '一緒に運動したり、スポーツ観戦を楽しもう。',                           icon_class: 'ri-football-line',       member_count: 294 },
  { name: 'アニメ・ゲーム',     tag: 'アニメ・ゲーム', description: '推し活・ゲームの話で盛り上がろう！',                               icon_class: 'ri-gamepad-line',        member_count: 389 },
  { name: '映画部',            tag: '映画',         description: '映画好きで集まって感想戦をしよう。試写会情報も共有！',                   icon_class: 'ri-movie-line',          member_count: 276 },
  { name: '料理好き',          tag: '料理',         description: 'レシピを共有したり、一緒に料理しよう。食の探求仲間募集。',             icon_class: 'ri-chef-hat-line',       member_count: 203 },
  { name: 'アート・写真部',     tag: 'アート・写真', description: '作品を見せ合ったり、一緒に美術館・展覧会へ行こう。',                   icon_class: 'ri-camera-line',         member_count: 148 },
  { name: 'ファッション部',     tag: 'ファッション', description: 'コーデを語ったり、一緒にショッピングを楽しもう。',                     icon_class: 'ri-t-shirt-line',        member_count: 312 },
  { name: 'ビジネス交流会',     tag: 'ビジネス',     description: 'スタートアップ・副業・キャリアアップを語り合おう。',                   icon_class: 'ri-briefcase-line',      member_count: 195 },
  { name: 'ペット好き',        tag: 'ペット',       description: 'ペットの話や一緒にお散歩・ドッグランへ行こう。',                       icon_class: 'ri-dog-line',            member_count: 267 },
  { name: 'クリエイター集会',   tag: 'クリエイター', description: 'デザイン・動画・イラストを語り合う仲間募集！',                       icon_class: 'ri-palette-line',        member_count: 221 },
  { name: 'ヨガ・フィットネス', tag: 'スポーツ',     description: '一緒に体を動かそう。ジムやヨガスタジオの情報を交換。',                 icon_class: 'ri-selfie-line',         member_count: 178 },
  { name: '山手線コミュニティ', tag: '沿線仲間',     description: '山手線沿線に住む・通う人のコミュニティ。地元情報を共有。',             icon_class: 'ri-train-line',          member_count: 634 },
  { name: '中央線沿線',         tag: '沿線仲間',     description: '中央線ユーザーの集まり。沿線のおすすめスポットを共有。',               icon_class: 'ri-subway-line',         member_count: 489 },
]

communities_data.each do |attrs|
  Community.find_or_create_by!(name: attrs[:name]) do |c|
    c.assign_attributes(attrs)
  end
end

puts "  ✅ #{Community.count} communities"

# ── ユーザー ──────────────────────────────────────────────────────
puts "🌱 Seeding users..."

LINES = %w[
  JR山手線 JR中央線 JR総武線 JR埼京線 JR京浜東北線
  東急東横線 東急田園都市線 小田急線 京王線
  東京メトロ丸ノ内線 東京メトロ銀座線 東京メトロ半蔵門線
  東京メトロ副都心線 都営大江戸線 西武池袋線 東武東上線
].freeze

# 画像はプレースホルダーURL（本番では実画像URLに差し替え）
users_data = [
  # ── 女性ユーザー ──────────────────────────────────────────
  {
    email: 'hanako@example.com', name: '田中花子', age: 25, gender: 'womens',
    image_url: 'https://randomuser.me/api/portraits/women/1.jpg',
    line: LINES[0], distance_km: 10.5,
    bio: '数あるプロフィールの中から見つけていただき、ありがとうございます！音楽が生活の一部で、週末はライブハウスやフェスに行くのが楽しみです。レコードショップ巡りにもハマっています。',
    sub_images: [
      'https://randomuser.me/api/portraits/women/2.jpg',
      'https://randomuser.me/api/portraits/women/3.jpg',
    ],
    community_indices: [0, 5],
  },
  {
    email: 'misaki@example.com', name: '佐藤美咲', age: 23, gender: 'womens',
    image_url: 'https://randomuser.me/api/portraits/women/4.jpg',
    line: LINES[1], distance_km: 17.4,
    bio: '都内のカフェ巡りに没頭しています☕ カメラを片手にふらふら散策するのが好きです。笑いのツボが合う方と出会いたいです！',
    sub_images: [
      'https://randomuser.me/api/portraits/women/5.jpg',
      'https://randomuser.me/api/portraits/women/6.jpg',
    ],
    community_indices: [0, 4],
  },
  {
    email: 'yumi@example.com', name: '鈴木由美', age: 27, gender: 'womens',
    image_url: 'https://randomuser.me/api/portraits/women/7.jpg',
    line: LINES[2], distance_km: 24.6,
    bio: 'ヨガとハイキングが好きなWebデザイナーです。自然の中でエネルギーをチャージしています。お互いに自立した関係を築けたらと思っています。',
    sub_images: [
      'https://randomuser.me/api/portraits/women/8.jpg',
      'https://randomuser.me/api/portraits/women/9.jpg',
    ],
    community_indices: [3, 15],
  },
  {
    email: 'keiko@example.com', name: '山田恵子', age: 24, gender: 'womens',
    image_url: 'https://randomuser.me/api/portraits/women/10.jpg',
    line: LINES[3], distance_km: 31.0,
    bio: '映画と本が大好きです。月に10本以上観ています。映画を観た後に感想を語り合えるパートナーを探しています。',
    sub_images: [
      'https://randomuser.me/api/portraits/women/11.jpg',
      'https://randomuser.me/api/portraits/women/12.jpg',
    ],
    community_indices: [8, 5],
  },
  {
    email: 'mai@example.com', name: '伊藤麻衣', age: 26, gender: 'womens',
    image_url: 'https://randomuser.me/api/portraits/women/13.jpg',
    line: LINES[4], distance_km: 7.5,
    bio: '旅と好奇心が原動力です。15カ国以上を旅してきました。アパレルの仕事をしています。一緒に新しい世界に飛び込めるパートナーと出会いたいです！',
    sub_images: [
      'https://randomuser.me/api/portraits/women/14.jpg',
      'https://randomuser.me/api/portraits/women/15.jpg',
    ],
    community_indices: [2, 11],
  },
  # ── 男性ユーザー ──────────────────────────────────────────
  {
    email: 'taro@example.com', name: '山本太郎', age: 28, gender: 'mens',
    image_url: 'https://randomuser.me/api/portraits/men/1.jpg',
    line: LINES[0], distance_km: 8.2,
    bio: 'IT企業でエンジニアをしています。週末はロードバイクか登山。アウトドアが好きな方、一緒に自然を楽しみましょう！話しかけやすい方が好きです。',
    sub_images: [
      'https://randomuser.me/api/portraits/men/2.jpg',
      'https://randomuser.me/api/portraits/men/3.jpg',
    ],
    community_indices: [3, 6],
  },
  {
    email: 'kenji@example.com', name: '佐々木健二', age: 30, gender: 'mens',
    image_url: 'https://randomuser.me/api/portraits/men/4.jpg',
    line: LINES[5], distance_km: 14.0,
    bio: '料理が趣味のサラリーマンです。休日は新しいレシピに挑戦しています。一緒においしいものを食べに行ける方を探しています。',
    sub_images: [
      'https://randomuser.me/api/portraits/men/5.jpg',
      'https://randomuser.me/api/portraits/men/6.jpg',
    ],
    community_indices: [4, 9],
  },
  {
    email: 'ryota@example.com', name: '中村亮太', age: 25, gender: 'mens',
    image_url: 'https://randomuser.me/api/portraits/men/7.jpg',
    line: LINES[6], distance_km: 20.3,
    bio: '映画とアートが好きなフリーランスデザイナーです。美術館や映画館によく行きます。感性が合う方と出会えたら嬉しいです。',
    sub_images: [
      'https://randomuser.me/api/portraits/men/8.jpg',
      'https://randomuser.me/api/portraits/men/9.jpg',
    ],
    community_indices: [8, 10],
  },
  {
    email: 'shota@example.com', name: '高橋翔太', age: 27, gender: 'mens',
    image_url: 'https://randomuser.me/api/portraits/men/10.jpg',
    line: LINES[9], distance_km: 5.8,
    bio: '旅行と音楽が大好きです。バンドでギターを弾いています。国内外問わず旅行に行くのが好きで、一緒に旅できる方を探しています。',
    sub_images: [
      'https://randomuser.me/api/portraits/men/11.jpg',
      'https://randomuser.me/api/portraits/men/12.jpg',
    ],
    community_indices: [1, 2],
  },
  {
    email: 'daisuke@example.com', name: '田村大輔', age: 29, gender: 'mens',
    image_url: 'https://randomuser.me/api/portraits/men/13.jpg',
    line: LINES[7], distance_km: 28.5,
    bio: '体を動かすことが好きなトレーナーです。ジムやスポーツ観戦が趣味。健康的な生活を一緒に楽しめるパートナーを探しています。',
    sub_images: [
      'https://randomuser.me/api/portraits/men/14.jpg',
      'https://randomuser.me/api/portraits/men/15.jpg',
    ],
    community_indices: [6, 15],
  },
]

users_data.each do |attrs|
  sub_images = attrs.delete(:sub_images)
  community_indices = attrs.delete(:community_indices)

  user = User.find_or_create_by!(email: attrs[:email]) do |u|
    u.assign_attributes(attrs.except(:email))
    u.password = 'password123'
  end

  # サブ画像
  if user.user_images.empty?
    sub_images.each_with_index do |url, i|
      user.user_images.create!(image_url: url, position: i)
    end
  end

  # コミュニティ参加
  community_indices.each do |idx|
    community = Community.all[idx]
    CommunityMembership.find_or_create_by!(user: user, community: community) do |m|
      m.joined_at = Time.current
    end
  end
end

puts "  ✅ #{User.count} users"

# ── 掲示板投稿（汎用サンプル）────────────────────────────────────
puts "🌱 Seeding board posts..."

sample_user = User.first

board_posts_data = [
  { post_type: 'good',    content: '初めてのデートで行き先を全部リサーチしてくれていて、すごく楽しかったです。帰り道も駅まで送ってくれて紳士的でした。',                                                 helpful_count: 24, agree_count: 18, admin_reviewed: false },
  { post_type: 'good',    content: 'メッセージの返信がいつも丁寧で、こちらの話をちゃんと聞いてくれる方でした。会ってみても写真通りで安心できました。',                                                   helpful_count: 31, agree_count: 22, admin_reviewed: false },
  { post_type: 'good',    content: 'お店のキャンセルが急に必要になったとき、すぐに代替案を出してくれて頼もしかったです。',                                                                               helpful_count: 15, agree_count: 9,  admin_reviewed: false },
  { post_type: 'warning', content: '待ち合わせに20分以上遅れてきて謝罪もなし。事前の連絡もありませんでした（運営確認済み）。',                                                                           helpful_count: 42, agree_count: 38, admin_reviewed: true  },
  { post_type: 'warning', content: 'プロフィール写真と実物がかなり異なる方がいました。写真は数年前のものだったようです。事前に確認することをお勧めします（運営確認済み）。',                           helpful_count: 35, agree_count: 29, admin_reviewed: true  },
]

if BoardPost.none?
  board_posts_data.each do |attrs|
    BoardPost.create!(attrs.merge(target_user: sample_user))
  end
end

puts "  ✅ #{BoardPost.count} board_posts"

# ── いいね（taro へ女性3名からのいいね）────────────────────────────
puts "🌱 Seeding likes..."
taro = User.find_by(email: 'taro@example.com')
if taro
  %w[hanako@example.com misaki@example.com yumi@example.com].each do |email|
    liker = User.find_by(email: email)
    next unless liker
    Like.find_or_create_by!(from_user_id: liker.id, to_user_id: taro.id) do |l|
      l.action = 'like'
    end
  end
end
puts "  ✅ #{Like.count} likes"

puts "\n🎉 Seed 完了！"
