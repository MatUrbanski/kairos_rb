# frozen_string_literal: true

require 'securerandom'

module KairosRB
  class Client
    def initialize(app_id:, app_key:)
      @connection = KairosRB::Connection.new(
        app_id: app_id,
        app_key: app_key
      )
    end

    def enroll(image:, gallery_name:, subject_id:, selector: nil)
      body = { gallery_name: gallery_name, image: image, subject_id: subject_id, selector: selector }

      @connection.call(
        method: 'post',
        url: '/enroll',
        body: body.to_json,
        headers: { 'Content-Type' => 'application/json' }
      )
    end

    def verify(image:, gallery_name:, subject_id:, selector: nil)
      body = { gallery_name: gallery_name, image: image, subject_id: subject_id, selector: selector }

      @connection.call(
        method: 'post',
        url: '/verify',
        body: body.to_json,
        headers: { 'Content-Type' => 'application/json' }
      )
    end

    def recognize(image:, gallery_name:, selector: nil, min_head_scale: nil, threshold: nil, max_num_results: nil)
      body = {
        'image' => image,
        'gallery_name' => gallery_name,
        'selector' => selector,
        'MinHeadScale' => min_head_scale,
        'threshold' => threshold,
        'max_num_results' => max_num_results
      }

      @connection.call(
        method: 'post',
        url: '/recognize',
        body: body.to_json,
        headers: { 'Content-Type' => 'application/json' }
      )
    end

    def detect(image:, selector: nil, min_head_scale: nil)
      body = { 'image' => image, 'selector' => selector, 'MinHeadScale' => min_head_scale }

      @connection.call(
        method: 'post',
        url: '/detect',
        body: body.to_json,
        headers: { 'Content-Type' => 'application/json' }
      )
    end

    def all_galeries
      @connection.call(
        method: 'post',
        url: '/gallery/list_all',
        headers: { 'Content-Type' => 'application/json' }
      )
    end

    def gallery_details(gallery_name:)
      body = { gallery_name: gallery_name }

      @connection.call(
        method: 'post',
        url: '/gallery/view',
        body: body.to_json,
        headers: { 'Content-Type' => 'application/json' }
      )
    end

    def gallery_subject(gallery_name:, subject_id:)
      body = { gallery_name: gallery_name, subject_id: subject_id }

      @connection.call(
        method: 'post',
        url: '/gallery/view_subject',
        body: body.to_json,
        headers: { 'Content-Type' => 'application/json' }
      )
    end

    def remove_subject_from_gallery(gallery_name:, subject_id:)
      body = { gallery_name: gallery_name, subject_id: subject_id }

      @connection.call(
        method: 'post',
        url: '/gallery/remove_subject',
        body: body.to_json,
        headers: { 'Content-Type' => 'application/json' }
      )
    end

    def remove_gallery(gallery_name:)
      body = { gallery_name: gallery_name }

      @connection.call(
        method: 'post',
        url: '/gallery/remove',
        body: body.to_json,
        headers: { 'Content-Type' => 'application/json' }
      )
    end

    def add_media(media:, landmarks: 1, timeout: 10)
      @connection.call(
        method: 'post',
        url: "/v2/media?source=#{media}&landmarks=#{landmarks}&timeout=#{timeout}",
        headers: { 'Content-Type' => 'application/x-www-form-urlencoded' }
      )
    end

    def get_media(media_id:)
      @connection.call(
        method: 'get',
        url: "/v2/media/#{media_id}",
        headers: { 'Content-Type' => 'application/x-www-form-urlencoded' }
      )
    end

    def media_analytics(media_id:)
      @connection.call(
        method: 'get',
        url: "/v2/analytics/#{media_id}",
        headers: { 'Content-Type' => 'application/x-www-form-urlencoded' }
      )
    end

    def remove_media(media_id:)
      @connection.call(
        method: 'delete',
        url: "/v2/media/#{media_id}",
        headers: { 'Content-Type' => 'application/json' }
      )
    end
  end
end
