module Square
  class Instrumentation < ::Faraday::Middleware
    attr_reader :instrumenter

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
    rescue Faraday::Error => e
      instrumenter.instrument('square.api_request_error', {
        request_env: request_env,
        response_status: e.response_status,
        error_class: e.class.to_s,
        api_name: request_env.request.context&.fetch(:api_name, nil),
        started_at: started,
        ended_at: Time.now,
      })

      raise
    end
  end
end
