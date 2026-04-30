module Api
  module V1
    class UploadsController < Api::V1::BaseController
      before_action :authenticate_user!

      ALLOWED_EXTS = %w[.jpg .jpeg .png .webp].freeze

      def create
        file = params.require(:file)
        ext  = normalize_ext(file.original_filename, file.content_type)
        path = "profiles/#{current_user.id}/#{SecureRandom.uuid}#{ext}"

        url = SupabaseStorageService.new.upload(file: file, path: path)
        render json: { url: url }
      rescue => e
        render json: { error: e.message }, status: :unprocessable_entity
      end

      private

      def normalize_ext(filename, content_type)
        ext = File.extname(filename.to_s).downcase
        return ext if ALLOWED_EXTS.include?(ext)

        case content_type.to_s
        when /png/  then '.png'
        when /webp/ then '.webp'
        else '.jpg'
        end
      end
    end
  end
end
