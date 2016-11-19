module Vicki
  module Commands
    class Audience < SlackRubyBot::Commands::Base
      command 'audience' do |client, data, _match|
        uri = URI('http://localhost:3000/api/audits')
        req = Net::HTTP::Post.new(uri)
        req.set_form_data("youtube_url" => _match[:expression], 'email' => client.users[data.user].profile.email)

        res = Net::HTTP.start(uri.hostname, uri.port) do |http|
          http.request(req)
        end
        case res
        when Net::HTTPSuccess, Net::HTTPRedirection
          client.say channel: data.channel, text: "I'm crunching the numbers now, you will get an email soon."
        else
          client.say channel: data.channel, text: res.body
        end
      end
    end
  end
end
