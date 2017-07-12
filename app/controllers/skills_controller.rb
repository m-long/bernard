class SkillsController < ApplicationController
  include MqttHelper

  # Before Actions
  skip_before_action :verify_authenticity_token
  wrap_parameters false

  def interface
    input = AlexaRubykit::build_request(params)
    output = AlexaRubykit::Response.new
    session_end = true
    message = "There was an error."
    voice_response = "I'm sorry, there was an error."

    # Initialize variables
    location = ""
    device = ""
    mqtt_topic = "uid"

    case input.type.upcase
    when "LAUNCH_REQUEST"
      # User talked to Bernard but did not say something matching an intent"
      voice_response = "This is Bernard. How can I help you?"
    when "SESSION_ENDED_REQUEST"
      # it's over
      message = ""
      voice_response = ""
    when "INTENT_REQUEST"
      input_name  = input.name.downcase
      input_slots = input.slots
      # not memory or speed optimized but works for now
      alexa_skill_intents = AlexaSkillIntent.all
      alexa_skill_intents.each do |intent|
        if intent.name.downcase == input_name
          message = intent.message
          voice_response = intent.voice_response
          intent.slots.each do |slot|
            if input_slots[slot.name]
              slot_value = input_slots[slot.name]["value"]
              message << " #{slot_value}"
              logger.info "Slot detected, message is #{message}"
            end
          end
          # Craft MQTT topic | make this a separate function later?
          device = input_slots["Device"]["value"].downcase if input_slots["Device"]
          room   = input_slots["Room"]["value"].downcase if input_slots["Room"]
          mqtt_topic << "/#{room}" if !room.nil?
          mqtt_topic << "/#{device}" if !device.nil?

          # Send MQTT Command
          send_mqtt_command mqtt_topic, message
          logger.info "MQTT Topic: #{mqtt_topic}"
          break # stop iterating through intents
        end
      end
    end

    c_type = "Simple"
    c_title = "Bernard"
    c_subtitle = "Bedroom TV"
    # output.add_card(c_type, c_title, c_subtitle, message) unless message.blank?

    output.add_speech(voice_response) unless voice_response.blank?
    render json: output.build_response(session_end)
  end
end
