# frozen_string_literal: true

require "sinatra"
require "sinatra/json"

module Mihari
  module Controllers
    class CommandController < Sinatra::Base
      post "/api/command" do
        payload = JSON.parse(request.body.read)

        command = payload["command"]
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
