module Vicki
  module Commands
    class Url < SlackRubyBot::Commands::Base
      match %r{<(?<url>.*?)[>|]} do |client, data, match|
        url = Yt::URL.new match[:url]
        next if url.kind == :unknown

        client.say channel: data.channel, text: <<~TEXT
        *#{url.kind} #{url.id}*
        ```
        SNIPPET
          Title: #{url.resource.title}
          Description: #{url.resource.description[0..30]}#{'...' if url.resource.description.length > 30}
          Published at: #{url.resource.published_at}
        ```
        TEXT
      end
    end
  end
end
