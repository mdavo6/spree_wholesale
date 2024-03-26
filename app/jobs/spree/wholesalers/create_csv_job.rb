module Spree
    module Wholesalers
        class CreateCsvJob < Spree::BaseJob
            queue_as :spree_wholesalers_create_csv

            def perform(user)

                wholesalers = Spree::Wholesaler.all

                require 'csv'

                header = ['Store', 'Buyer', 'Email', 'Date of last order', 'Total sales (AUD)', 'Total sales (USD)', 'Total orders', 'Average order value (AUD)', 'Average order value (USD)', 'Phone number', 'Address1', 'City', 'State', 'Postcode', 'Country', 'Days since last order']

                csv_file = CSV.generate(headers: true) do |csv|
                    csv << header

                    wholesaler_attrs = {}

                    wholesalers.each do |wholesaler|
                        wholesaler_attrs['Store'] = wholesaler.company
                        wholesaler_attrs['Buyer'] = wholesaler.buyer
                        wholesaler_attrs['Email'] = wholesaler.user.email

                        total_orders = wholesaler.user.order_count
                        if total_orders > 0
                            wholesaler_attrs['Date of last order'] = wholesaler.user.orders.complete.reverse_chronological.first.updated_at.strftime('%d/%m/%Y')
                            wholesaler_attrs['Days since last order'] = (Date.today - wholesaler.user.orders.reverse_chronological.first.updated_at.to_date).to_i
                        else
                            wholesaler_attrs['Date of last order'] = 'N/A'
                            wholesaler_attrs['Days since last order'] = 'N/A'
                        end
                        wholesaler_attrs['Total sales (AUD)'] = wholesaler.user.display_total_lifetime_value(currency: 'AUD').to_s
                        wholesaler_attrs['Total sales (USD)'] = wholesaler.user.display_total_lifetime_value(currency: 'USD').to_s
                        wholesaler_attrs['Total orders'] = wholesaler.user.total_order_count
                        wholesaler_attrs['Average order value (AUD)'] = wholesaler.user.display_total_average_order_value(currency: 'AUD').to_s
                        wholesaler_attrs['Average order value (USD)'] = wholesaler.user.display_total_average_order_value(currency: 'USD').to_s
                        wholesaler_attrs['Phone number'] = wholesaler.phone
                        if wholesaler.user.addresses.present?
                            wholesaler_attrs['Address1'] = wholesaler.user.addresses.first.address1.to_s
                            wholesaler_attrs['City'] = wholesaler.user.addresses.first.city.to_s
                            if wholesaler.user.addresses.first.state.present?
                                wholesaler_attrs['State'] = wholesaler.user.addresses.first.state.abbr.to_s
                            else
                                wholesaler_attrs['State'] = ''
                            end
                            wholesaler_attrs['Postcode'] = wholesaler.user.addresses.first.zipcode.to_s
                            wholesaler_attrs['Country'] = wholesaler.user.addresses.first.country.name.to_s

                            #   wholesaler_attrs['Address1'] = wholesaler.user.shipping_address.address1.to_s
                            # elsif wholesaler.ship_address.present?
                            #   wholesaler_attrs['Address1'] = wholesaler.ship_address.address1.to_s
                            # elsif wholesaler.user.addresses.present?
                            #   wholesaler_attrs['Address1'] = wholesaler.user.addresses.first.address1.to_s
                        else
                            wholesaler_attrs['Address1'] = ''
                            wholesaler_attrs['City'] = ''
                            wholesaler_attrs['Postcode'] = ''
                            wholesaler_attrs['Country'] = ''
                        end
                        csv << wholesaler_attrs
                    end
                end
                Spree::WholesaleMailer.csv_export_email(csv_file, user).deliver_now
            end
        end
    end
end