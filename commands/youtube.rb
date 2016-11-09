module Vicki
  module Commands
    class YouTube < SlackRubyBot::Commands::Base
      scan %r{UC[a-zA-Z0-9_-]{22}} do |client, data, channel_ids|
        channels = Yt::Channel.where(id: channel_ids).select(:snippet, :status)
        channels.each do |channel|
          snippet = <<~TEXT
          SNIPPET
            Title: #{channel.title}
            Description: #{channel.description[0..30]}#{'...' if channel.description.length > 30}
            Published at: #{channel.published_at}
          TEXT

          status = <<~TEXT
          STATUS
            Privacy status: #{channel.privacy_status}
            Is linked: #{channel.is_linked}
            Long upload status: #{channel.long_upload_status}
          TEXT

          statistics = <<~TEXT
          STATISTICS
            View count: #{channel.view_count}
            Comment count: #{channel.comment_count}
            Subscriber count: #{channel.subscriber_count}
            Hidden subscriber count: #{channel.hidden_subscriber_count}
            Video count: #{channel.video_count}
          TEXT

          video = nil #channel.videos.select(:snippet).first
          most_recent_video =  video.nil? ? nil : <<~TEXT
          MOST RECENT VIDEO
            Title: #{video.title}
            Description: #{video.description[0..30]}#{'...' if video.description.length > 30}
            Published at: #{video.published_at}
          TEXT

          client.say channel: data.channel, text: <<~TEXT
          *Channel #{channel.id}*
          ```#{snippet}#{status}#{statistics}#{most_recent_video}```
          TEXT
        end
      end
    end
  end
end
