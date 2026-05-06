RSpec.configure do |config|
  config.around(:each) do |example|
    tag = "#{example.metadata[:described_class]} | #{example.description}"
    Rails.logger.tagged(tag) { example.run }
  end
end
