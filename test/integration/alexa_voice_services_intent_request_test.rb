require 'test_helper'

class AlexaVoiceServicesIntentRequestTest < ActionDispatch::IntegrationTest

  def setup
    @alexa_skill_intents = AlexaSkillIntent.all
    @raw_aws_json_body = {
      session: {
        sessionId: "SessionId.7063772a-87af-4f2a-90d2-ed5f6cd5d1fa",
        application: {
          applicationId: "amzn1.ask.skill.d0be4df4-e209-44a1-a993-9ebd42d258fc"
        },
        attributes: {},
        user: {
          userId: "test_user_id"
        },
        new: true
      },
      request: {
        type: "IntentRequest",
        requestId: "EdwRequestId.ba8a8235-6b61-410b-92ec-a1f8b608fcc4",
        locale: "en-US",
        timestamp: "#{Time.zone.now}",
        intent: {
          slots: { }
        }
      },
      version: "1.0"
    }
  end

  test "all intents for Bernard's device control work properly" do
    # Prepare json post request
    @alexa_skill_intents.each do |intent|
      post_request = @raw_aws_json_body
      assert_not post_request.nil?
      post_request[:request][:intent][:name] = intent.name
      if intent.slots
        intent.slots.each do |slot|
          post_request[:request][:intent][:slots][slot.name] = { "name" => slot.name } 
          if slot.test_value
            post_request[:request][:intent][:slots][slot.name]["value"] = slot.test_value
          end
        end
      end
      # Send the post request
      post interface_path, params: post_request, as: :json
      assert_response :success
      # Confirm proper response sent to AVS
      json_response = response.parsed_body
      assert_includes json_response["response"]["outputSpeech"]["text"], intent.voice_response
    end
  end
end
