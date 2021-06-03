module Square
  class Instrumentation < ::Faraday::Middleware
    attr_reader :instrumenter
    API_SERVICE_PATTERN = %r[/v2/([^/]+)/.*]

    def initialize(app, instrumenter: ActiveSupport::Notifications)
      super(app)
      @instrumenter = instrumenter
    end

    def call(request_env)
      started = Time.now

      @app.call(request_env).on_complete do |response_env|
        ended = Time.now

        instrumenter.instrument('square.api_request', {
          request_env: request_env,
          response_env: response_env,
          api_name: request_env.request.context&.fetch(:api_name, nil),
          started_at: started,
          ended_at: ended,
        })
      end
    end
  end
end
