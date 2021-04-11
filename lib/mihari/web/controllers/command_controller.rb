# frozen_string_literal: true

require "safe_shell"

module Mihari
  module Controllers
    class CommandController < BaseController
      post "/api/command" do
        param :command, String, required: true

        command = params["command"]
        if command.nil?
          status 400
          return json({ message: "command is required" })
        end

        command = command.split

        output = SafeShell.execute("mihari", *command)
        success = $?.success?

        json({ output: output, success: success })
      end
    end
  end
end
