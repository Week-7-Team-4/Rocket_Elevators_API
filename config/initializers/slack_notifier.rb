module SlackNotifier
    MESSAGE = Slack::Notifier.new ENV["SLACK_WEBHOOK"]  #define MESSAGE for use in elevator controller
end

