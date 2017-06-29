class SkillsController < ApplicationController
  include MqttHelper

  # Before Actions
  skip_before_action :verify_authenticity_token

  def interface
    input = AlexaRubykit::build_request(params)
    output = AlexaRubykit::Response.new
    session_end = true
    message = "There was an error"

    case input.type
    when "LAUNCH_REQUEST"
      # user talked to our skill but did not say something matching intent
      message = "This is Bernard. How can I help you?"
    when "INTENT_REQUEST"
      case input.name
      when "CyclePower"
        # our custom, simple intent from above that user matched
        message = "Tv power."
        send_command(message)
      when "VolumeUp"
        message = "Turn volume up"

        count = input.slots["Count"]["value"] || 1
        if count.to_i && count.to_i > 1
          message << " by #{count}"
        end

        send_command(message)
      when "VolumeDown"
        message = "Turn volume down"

        count = input.slots["Count"]["value"] || 1
        if count.to_i && count.to_i > 1
          message << " by #{count}"
        end

        send_command(message)
      when "VolumeMute"
        message = "Tv muted."
        command = "volume mute"
        send_command(command)
      when "ChannelUp"
        message = "Turn channel up"

        count = input.slots["Count"]["value"] || 1
        if count.to_i && count.to_i > 1
          message << " by #{count}"
        end

        send_command(message)
      when "ChannelDown"
        message = "Turn channel down"

        count = input.slots["Count"]["value"] || 1
        if count.to_i && count.to_i > 1
          message << " by #{count}"
        end

        send_command(message)
      when "ChannelSet"
        channel_number = input.slots["ChannelNumber"]["value"]
        if channel_number && channel_number.to_i >=0
          message = "Change channel to #{channel_number}"
          send_command(message)
        else
          message = "Sorry, I did not understand that channel number."
        end
      when "ChannelPrevious"
        message = "Previous channel"

        send_command(message)
      when "ChangeSource"
        message = "Change source"

        tv_source = input.slots["TVSource"]["value"]
        if tv_source && [ "cable", "tv"].include?(tv_source.downcase)
          message << " to #{tv_source}"
        end
        send_command(message)
      end
    when "SESSION_ENDED_REQUEST"
      # it's over
      message = nil
    end

    c_type = "Simple"
    c_title = "Bernard"
    c_subtitle = "TV Remote"
    # output.add_card(c_type, c_title, c_subtitle, message) unless message.blank?

    output.add_speech(message) unless message.blank?
    render json: output.build_response(session_end)
  end

  private

    def send_command(tv_command)
      MQTT::Client.connect(
        host: 'mqtt.mattlong.la',
        port: 8883,
        username: 'matt',
        password: 'fuckthis',
        ssl: true
      ) do |c|
        c.publish("Samsung", "#{tv_command.downcase}")
      end
    end
end
  end
end
