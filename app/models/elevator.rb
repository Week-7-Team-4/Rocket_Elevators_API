require 'date'  #gem use to format timestamp at the end of the message

class Elevator < ApplicationRecord
    belongs_to :column ,optional: true

    before_save :twilio_sms

    def twilio_sms

        if self.status == "intervention" or self.status == "Intervention" 
            account_sid = ENV["TWILIO_ACCOUNT_SID"]
            auth_token = ENV["TWILIO_AUTH_TOKEN"]
            number_from = '+18124616988'
            number_to = self.column.battery.building.tech_contact_phone
            @client = Twilio::REST::Client.new(account_sid, auth_token)
            message = @client.messages.create(
                from: number_from,
                body: "Mr/Mrs #{self.column.battery.building.tech_contact_full_name} the elevator whose id:#{self.id} and serial number:#{self.serial_number} changed its status to #{self.status}, please check.",
                to: number_to,)  
            puts message.sid 
        end 
    end
    before_update :slack_message
    def slack_message
      
        timestamp = DateTime.now.strftime("%d-%m-%Y %H:%M")         #to format timestamp at the end of the message
        SlackNotifier::MESSAGE.ping "The Elevator #{self.id} with Serial Number #{self.serial_number} changed status from #{self.status_was} to #{self.status} at #{timestamp}."    #message to Slack channel via Team-#4 app (WebHook)
    end
end

