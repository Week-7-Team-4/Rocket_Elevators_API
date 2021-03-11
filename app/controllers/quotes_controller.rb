class QuotesController < ApplicationController
    def new
        @quote = Quote.new
    end

    def create
        @quote = Quote.new(quote_params)

        if @quote.final_price != '0.00 $' && @quote.final_price != '-$NaN' && @quote.save
            # fact_quotes()
            redirect_to main_app.root_path, notice: "Quote sent!"
        else    
            redirect_to "/quotes", notice: "Invalid fields!"
        end
    end

    # private
    # def fact_quotes
    # dwh = PG::Connection.new(host: 'codeboxx-postgresql.cq6zrczewpu2.us-east-1.rds.amazonaws.com', port: 5432, dbname: "MaximeAuger_psql", user: "codeboxx", password: "Codeboxx1!")
    #   dwh.exec("TRUNCATE fact_quotes")
    #   dwh.prepare('to_fact_quotes', 'INSERT INTO fact_quotes (quote_id, creation, company_name, email, nb_elevator, created_at, updated_at) VALUES ($1, $2, $3, $4, $5, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)')
    #   Quote.all.each do |quotes|
    #   dwh.exec_prepared('to_fact_quotes', [quotes.id, quotes.created_at, quotes.quotes_company_name, quotes.quotes_email, quotes.elevator_amount])
    #   end
    # end
  
    def quote_params
      params.require(:quote).permit(:number_of_apartments, :number_of_floors, :company_name, :number_of_basements,
      :number_of_companies, :number_of_corporations, :number_of_parking, :number_of_elevators, :maximum_occupancy,
      :business_hours, :product_line, :install_fees, :total_price, :unit_price, :building_type, :final_price,
      :elevator_amount, :quotes_name, :quotes_email, :quotes_company_name)
    end
end