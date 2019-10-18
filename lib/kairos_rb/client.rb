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
  end
end
