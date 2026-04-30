module JsonWebToken
  EXPIRY = 30.days

  def self.encode(payload)
    payload = payload.merge(exp: EXPIRY.from_now.to_i)
    JWT.encode(payload, secret)
  end

  def self.decode(token)
    JWT.decode(token, secret).first.with_indifferent_access
  rescue JWT::DecodeError
    nil
  end

  def self.secret
    Rails.application.secret_key_base
  end
  private_class_method :secret
end
