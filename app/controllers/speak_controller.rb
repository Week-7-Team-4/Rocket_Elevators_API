class SpeakController < ApplicationController
    require "ibm_watson/authenticators"
    require "ibm_watson/text_to_speech_v1"
    include IBMWatson
        
        def speech
    
            authenticator = Authenticators::IamAuthenticator.new(
                 apikey: ENV["IBMapikey"]
            )
            text_to_speech = TextToSpeechV1.new(
                authenticator: authenticator
            )
    
            text_to_speech.service_url = "https://api.us-east.text-to-speech.watson.cloud.ibm.com/instances/1bee1baa-3704-4400-839b-e3a329a8740b"
            employee = Employee.find_by(user_id: current_user.id)
            File.open("#{Rails.root}/app/assets/audios/watson.mp3", "wb") do |audio_file|
                response = text_to_speech.synthesize(
                    text: "Hello #{employee.first_name} #{employee.last_name} There are currently #{Elevator.count} elevators deployed in the #{Building.count} buildings of your #{Customer.count} customers. Currently, #{Elevator.where.not(status: "online").count} elevators are not in Running Status and are being serviced. You currently have #{Quote.count} quotes awaiting processing. You currently have #{Lead.count} leads in your contact requests #{Battery.count} Batteries are deployed across #{Address.distinct.count(:city)} cities",
                    accept: "audio/mp3",
                    voice: "en-US_AllisonVoice"
                ).result
            audio_file << response
            end
    
        end
       
    end


#{Elevator.where.not(status: "online").count}