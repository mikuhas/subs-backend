require 'net/http'
require 'uri'
require 'json'

class SupabaseStorageService
  BUCKET     = 'profiles'
  EXPIRES_IN = 315_360_000 # 10年（秒）

  def upload(file:, path:)
    supabase_url = ENV.fetch('SUPABASE_URL')
    service_key  = ENV.fetch('SUPABASE_SERVICE_ROLE_KEY')

    http = build_http(supabase_url)

    upload_object(http, supabase_url, service_key, file, path)
    signed_url(http, supabase_url, service_key, path)
  end

  private

  def build_http(supabase_url)
    uri  = URI(supabase_url)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = uri.scheme == 'https'
    http
  end

  def upload_object(http, supabase_url, service_key, file, path)
    uri = URI("#{supabase_url}/storage/v1/object/#{BUCKET}/#{path}")
    req = Net::HTTP::Post.new(uri)
    req['Authorization'] = "Bearer #{service_key}"
    req['Content-Type']  = file.content_type.presence || 'image/jpeg'
    req['x-upsert']      = 'true'
    req.body = file.read

    res = http.request(req)
    raise "Supabase upload failed (#{res.code}): #{res.body}" unless res.is_a?(Net::HTTPSuccess)
  end

  def signed_url(http, supabase_url, service_key, path)
    uri = URI("#{supabase_url}/storage/v1/object/sign/#{BUCKET}/#{path}")
    req = Net::HTTP::Post.new(uri)
    req['Authorization'] = "Bearer #{service_key}"
    req['Content-Type']  = 'application/json'
    req.body = JSON.generate({ expiresIn: EXPIRES_IN })

    res = http.request(req)
    raise "Supabase sign failed (#{res.code}): #{res.body}" unless res.is_a?(Net::HTTPSuccess)

    body = JSON.parse(res.body)
    "#{supabase_url}/storage/v1#{body['signedURL']}"
  end
end
