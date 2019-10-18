# frozen_string_literal: true

module KairosRB
  class Connection
    def initialize(app_id:, app_key:)
      @app_id  = app_id
      @app_key = app_key

      @connection = Faraday.new(
        'https://api.kairos.com'
      ) do |conn|
        conn.response :json, content_type: /\bjson$/
        conn.use      Faraday::Response::RaiseError
        conn.adapter  Faraday.default_adapter
      end
    end

    def call(url:, method:, headers: {}, body: nil)
      default_headers = { 'app_id' => @app_id, 'app_key' => @app_key }
      all_headers     = default_headers.merge(headers)

      body = @connection.send(method, url) do |req|
        req.body    = body
        req.headers = req.headers.merge(all_headers)
      end.body
    end
  end
end
