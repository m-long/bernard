class SkillsController < ApplicationController
  include MqttHelper

  # Before Actions
  skip_before_action :verify_authenticity_token
  wrap_parameters false

  def interface
    input = AlexaRubykit::build_request(params)
    output = AlexaRubykit::Response.new
    session_end = true
    message = "There was an error"

    alexa_skill_intents = AlexaSkillIntent.all

    case input.type.upcase
    when "LAUNCH_REQUEST"
      # User talked to Bernard but did not say something matching an intent"
      message = "This is Bernard. How can I help you?"
    when "SESSION_ENDED_REQUEST"
      # it's over
      message = nil
    when "INTENT_REQUEST"
      input_name  = input.name.downcase
      input_slots = input.slots
      # not memory or speed optimized but works for now
      alexa_skill_intents.each do |intent|
        if intent.name.downcase == input_name
          message = intent.voice_response
          intent.slots.each do |slot|
            if input_slots[slot]
              slot_value = input_slots[slot]["value"]
              message << " #{slot_value}"
            end
          end
        end
      end
    end

    c_type = "Simple"
    c_title = "Bernard"
    c_subtitle = "TV Remote"
    # output.add_card(c_type, c_title, c_subtitle, message) unless message.blank?

    output.add_speech(message) unless message.blank?
    render json: output.build_response(session_end)
  end

  def old_interface
    input  = AlexaRubykit::build_request(params)
    output = AlexaRubykit::Response.new
    session_end = true
    message = "There was an error"

    case input.type
    when "LAUNCH_REQUEST"
      # user talked to our skill but did not say something matching intent
      message = "This is Bernard. How can I help you?"
    when "INTENT_REQUEST"
      case input.name
      when "PowerCycle"
        # our custom, simple intent from above that user matched
        message = "Tv power."
        send_command(message)
      when "VolumeChange"
        direction = input.slots["Direction"]["value"]
        message = "Turn volume #{direction}"

        if input.slots["Count"]
          count = input.slots["Count"]["value"] || 1
        else
          count = 1
        end
        if count.to_i && count.to_i > 1
          message << " by #{count}"
        end

        send_command(message)
      when "VolumeMute"
        message = "Tv muted."
        command = "volume mute"
        send_command(command)
      when "ChannelChange"
        direction = input.slots["Direction"]["value"]
        message = "Turn channel #{direction}"

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
      when "SourceChange"
        message = "Change source"
        if input.slots && input.slots["TVSource"]
          tv_source = input.slots["TVSource"]["value"]
          if tv_source && [ "cable", "tv"].include?(tv_source.downcase)
            message << " to #{tv_source}"
          end
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
        host: 'bernard.mattlong.la',
        port: 8883,
        username: 'matt',
        password: 'fuckthis',
        ssl: true
      ) do |c|
        c.publish("Samsung", "#{tv_command.downcase}")
      end
    end
end
