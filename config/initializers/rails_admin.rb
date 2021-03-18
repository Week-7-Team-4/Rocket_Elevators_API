require Rails.root.join('lib', 'rails_admin', 'gmap.rb')

RailsAdmin.config do |config|
  ### Popular gems integration
  config.authorize_with do
    
    if current_user
      redirect_to main_app.root_path unless current_user.admin == true
    else 
      redirect_to main_app.root_path
    end
  end
  
  
    # Sync Data Warehouse with official Database

  ## == Devise ==
  # config.authenticate_with do
  #   warden.authenticate! scope: :user
  # end
  # config.current_user_method(&:current_user)

  ## == CancanCan ==
  # config.authorize_with :cancancan

  ## == Pundit ==
  # config.authorize_with :pundit

  ## == PaperTrail ==
  # config.audit_with :paper_trail, 'User', 'PaperTrail::Version' # PaperTrail >= 3.0.0

  ### More at https://github.com/sferik/rails_admin/wiki/Base-configuration

  ## == Gravatar integration ==
  ## To disable Gravatar integration in Navigation Bar set to false
  # config.show_gravatar = true

  config.actions do
    dashboard                     # mandatory
    index                         # mandatory
    new
    export
    bulk_delete
    show
    edit
    delete
    show_in_app
    gmap

    ## With an audit adapter, you can add:
    # history_index
    # history_show
  end

  config.navigation_static_links = {
    'Charts' => '/charts'
    
  }
end

require 'rails_admin/main_controller'

module RailsAdmin

  class MainController < RailsAdmin::ApplicationController
    protect_from_forgery prepend: true, with: :exception  
    skip_before_action :verify_authenticity_token
  end

end