class Quote < ApplicationRecord
    after_save :new_zendesk_ticket_quote

    def new_zendesk_ticket_quote
        client = ZendeskAPI::Client.new do |config|
            config.url = ENV['ZENDESK_URL']
            config.username = ENV["ZENDESK_EMAIL"]
            config.token = ENV["ZENDESK_TOKEN"]
        end
        ZendeskAPI::Ticket.create!(client,
        :subject => "#{self.quotes_name} from #{self.quotes_company_name}",
        :comment => {
            :value => "The contact #{self.quotes_name} from #{self.quotes_company_name} can be reach at this email: #{self.quotes_email}.
            
            The building type selected for the quote is #{self.building_type} with the product line #{self.product_line}.
            The number of elevator suggested is #{self.elevator_amount}, for a final price of #{self.final_price}.
            
            The final price include: #{self.elevator_amount} at $#{self.unit_price} per unit,
                                        total price of #{self.total_price} for all unit
                                        and the installation fees of #{self.install_fees}.  

            The Quote reference number is #{self.id}."
        },
  
        :priority => "normal",
        :type => "task"
        )
    end
end