# frozen_string_literal: true

require "safe_shell"

module Mihari
  module Endpoints
    class Command < Grape::API
      namespace :command do
        desc "Run a command", {
          success: Entities::CommandResult,
          failure: [{ code: 400, message: "Bad request", model: Entities::Message }]
        }
        params do
          requires :command, type: String, documentation: { param_type: "body" }
        end
        post "/" do
          command = params[:command]
          if command.nil?
            error!({ message: "command is required" }, 400)
          end

          command = command.split

          output = SafeShell.execute("mihari", *command)
          success = $?.success?

          present({ output: output, success: success }, with: Entities::CommandResult)
        end
      end
    end
  end
end
