module Middleware
  class CatchRackErrors
    def initialize(app)
      @app = app
    end         # def initialize

    def call(env)
      begin
        @app.call(env)
      rescue JWT::DecodeError => e
        return [
                 401,
                 { "Content-Type" => "application/json" },
                 [
                   {
                     message: "JWT token is invalid or expired",
                     error_code: "100011",
                   }.to_json,
                 ],
               ]
      end       # rescue
    end         # def call
  end           # class
end             # module
