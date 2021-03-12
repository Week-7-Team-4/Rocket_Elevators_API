require 'rails_admin/config/actions'
require 'rails_admin/config/actions/base'

module RailsAdmin
    module Config
      module Actions
        class Gmap < RailsAdmin::Config::Actions::Base
          RailsAdmin::Config::Actions.register(self)
  
          register_instance_option :root? do
            true
          end
          
          register_instance_option :breadcrumb_parent do
            nil
          end
          
          register_instance_option :auditing_versions_limit do
            100
          end         

          register_instance_option :visible? do
           bindings[:controller].main_app
          end
  
          register_instance_option :controller do
            proc do
              render :gmap
            end
          end
  
          register_instance_option :link_icon do
            'icon-map-marker'
          end
  
          register_instance_option :statistics? do
            false
          end
  
  
          register_instance_option :controller do
            proc do 
             
              
              p "Load maps......"
              request = "select cus.cpy_contact_full_name as nameadmin, 
                    b.tech_contact_full_name as nametech, 
                    CONCAT(ad.number_street,' ', ad.city ,' ',ad.postal_code,' ', ad.country )  as addresse,
                    ad.latitude as latitude,  
                    ad.longitude as longitude,
                    bitem.nbrofbat,
                    bitem.nbrofcol,
                    bitem.nbroffloor,
                    bitem.nbrofelev
                from buildings b
                join addresses ad on ad.building_id = b.id 
                join customers cus on cus.id = b.customer_id 
                join (
                    select batitemcount.building_id, 
                        count(batitemcount.bat_id) nbrofbat, 
                        sum(batitemcount.nbrofcol) nbrofcol,
                        sum(batitemcount.nbroffloor) nbroffloor,
                        sum(batitemcount.nbrofelev) nbrofelev
                    from (
                        SELECT bat.id bat_id, bat.building_id , 
                            sum(col.number_floors_served) nbroffloor,
                            count(col.id) nbrofcol,
                            (
                                select count(e.id) nbrofelev from `columns` c 
                                join elevators e on e.column_id  = c.id
                                where c.battery_id = bat.id
                                GROUP by c.battery_id
                            ) nbrofelev
                        from batteries bat 
                        join `columns` col on col.battery_id = bat.id 
                        GROUP by bat.id, bat.building_id 
                    ) as batitemcount
                    GROUP by batitemcount.building_id
                ) as bitem on bitem.building_id = b.id"
            
            p request
            resp = Building.find_by_sql(request);
          
             if resp.present? 
              @resp = resp
              else
                @resp = nil
              end
              # @resp = execute_statement()
              @hash = Gmaps4rails.build_markers(@resp) do |rep, marker|
                  _address = "No defined"
                  if !rep["addresse"].nil? 
                      _address = rep["addresse"]
                  end
                  
                  marker.lat rep["latitude"]
                  marker.lng rep["longitude"]
                  marker.infowindow "<b>Number of Floors:</b> "+ rep["nbroffloor"].to_s  + "</br><b>Client Full-Name:</b> "+ rep["nameadmin"]+ "</br> <b>Technician Full-Name:</b> "+rep["nametech"] + "</br> <b>Address:</b> "+ _address  + "</br> <b>Number of Battery:</b> " +rep["nbrofbat"].to_s + "</br> <b>Number of Columns:</b> "+rep["nbrofcol"].to_s + "</br> <b>Number of elevators:</b> "+rep["nbrofelev"].to_s
                  
              end
              p @hash
            
                
                
            end
            
            
            
                
              
          
          end

          def execute_statement()
                    
            request = "select cus.cpy_contact_full_name as nameadmin, 
                    b.tech_contact_full_name as nametech, 
                    CONCAT(ad.number_street,' ', ad.city ,' ',ad.postal_code,' ', ad.country )  as addresse,
                    ad.latitude as latitude,  
                    ad.longitude as longitude,
                    bitem.nbrofbat,
                    bitem.nbrofcol,
                    bitem.nbroffloor,
                    bitem.nbrofelev
                from buildings b
                join addresses ad on ad.building_id = b.id 
                join customers cus on cus.id = b.customer_id 
                join (
                    select batitemcount.building_id, 
                        count(batitemcount.bat_id) nbrofbat, 
                        sum(batitemcount.nbrofcol) nbrofcol,
                        sum(batitemcount.nbroffloor) nbroffloor,
                        sum(batitemcount.nbrofelev) nbrofelev
                    from (
                        SELECT bat.id bat_id, bat.building_id , 
                            sum(col.number_floors_served) nbroffloor,
                            count(col.id) nbrofcol,
                            (
                                select count(e.id) nbrofelev from `columns` c 
                                join elevators e on e.column_id  = c.id
                                where c.battery_id = bat.id
                                GROUP by c.battery_id
                            ) nbrofelev
                        from batteries bat 
                        join `columns` col on col.battery_id = bat.id 
                        GROUP by bat.id, bat.building_id 
                    ) as batitemcount
                    GROUP by batitemcount.building_id
                ) as bitem on bitem.building_id = b.id"
            
            p request
            resp = Building.find_by_sql(request);
          
             if resp.present? 
                return resp
              else
                return nil
              end
          end
  
        end
      end
    end
  end