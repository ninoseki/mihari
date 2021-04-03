# frozen_string_literal: true

require "json"

module Mihari
  module Notifiers
    class ExceptionNotifier
      def initialize
        @backtrace_lines = 10
        @color = "danger"

        @slack = Notifiers::Slack.new
      end

      def valid?
        @slack.valid?
      end

      def notify(exception)
        notify_to_stdout exception

        clean_message = exception.message.tr("`", "'")
        attachments = to_attachments(exception, clean_message)
        notify_to_slack(text: clean_message, attachments: attachments) if @slack.valid?
      end

      def notify_to_slack(text:, attachments:)
        @slack.notify(text: text, attachments: attachments)
      end

      def notify_to_stdout(exception)
        text = to_text(exception.class).chomp
        message = "#{text}: #{exception.message}"
        puts message
        puts format_backtrace(exception.backtrace) if exception.backtrace
      end

      def to_attachments(exception, clean_message)
        text = to_text(exception.class)
        backtrace = exception.backtrace
        fields = to_fields(clean_message, backtrace)

        [color: @color, text: text, fields: fields, mrkdwn_in: %w[text fields]]
      end

      def to_text(exception_class)
        measure_word = /^[aeiou]/i.match?(exception_class.to_s) ? "An" : "A"
        exception_name = "*#{measure_word}* `#{exception_class}`"
        "#{exception_name} *occured in background*\n"
      end

      def to_fields(clean_message, backtrace)
        fields = [
          { title: "Exception", value: clean_message },
          { title: "Hostname", value: hostname }
        ]

        if backtrace
          formatted_backtrace = format_backtrace(backtrace)
          fields << { title: "Backtrace", value: formatted_backtrace }
        end
        fields
      end

      def hostname
        Socket.gethostname
      rescue StandardError => _e
        "N/A"
      end

      def format_backtrace(backtrace)
        return nil unless backtrace

        "```#{backtrace.first(@backtrace_lines).join("\n")}```"
      end
    end
  end
end
