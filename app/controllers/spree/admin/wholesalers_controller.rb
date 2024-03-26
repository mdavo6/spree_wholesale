module Spree
  module Admin
    class WholesalersController < Spree::Admin::ResourceController
      respond_to :html, :xml
      before_action :approval_setup, :only => [ :approve, :reject ]
      after_action :persist_user_address, :only => [:create, :update]
      before_action :get_reps, :only => [:new, :edit]

      def index
        params[:q] ||= {}
        @search = ::Spree::Wholesaler.accessible_by(current_ability, :index).ransack(params[:q])
        if params[:q][:export_to_csv] == '1'
          @wholesalers = @search.result(distinct: true)
          #send_data export_csv(@wholesalers), filename: "wholesalers-#{Date.today}-#{Time.now}.csv"
          Spree::Wholesalers::CreateCsvJob.perform_later(spree_current_user)
          flash[:notice] = I18n.t('spree.admin.wholesaler.csv_export_success')
        else
          @wholesalers = @search.result(distinct: true).
            page(params[:page]).
            per(params[:per_page] || ::Spree::Config[:admin_orders_per_page])
          all_wholesalers = @search.result(distinct: true)
          @mapped_wholesalers = all_wholesalers.reject { |w| w.user.addresses.empty? }.map { |x|
            [x.company,
              x.user.has_store_address? ? x.user.addresses.store_address.first.latitude : x.user.addresses.first.latitude,
              x.user.has_store_address? ? x.user.addresses.store_address.first.longitude : x.user.addresses.first.longitude,
              x.active?,
              x.user.orders.complete.present? ? (Date.tomorrow - x.user.orders.reverse_chronological.first.updated_at.to_date).to_i : 0,
              x.faire
            ]
          }
          render
        end
      end

      def show
        @wholesaler = Spree::Wholesaler.find(params[:id])
        respond_with(@wholesaler)
      end

      def new
        @wholesaler = Spree::Wholesaler.new
        @wholesaler.build_user
        @wholesaler.bill_address = Spree::Address.default
        @wholesaler.ship_address = Spree::Address.default
        @wholesaler.visible_address = Spree::Address.default
        respond_with(@wholesaler)
      end

      def create
        @wholesaler = Spree::Wholesaler.new(wholesaler_params)
        if @wholesaler.save
          flash[:notice] = I18n.t('spree.admin.wholesaler.success')
          redirect_to spree.admin_wholesalers_path
        else
          flash[:error] = I18n.t('spree.admin.wholesaler.failed')
          get_reps
          render :new, status: :unprocessable_entity
        end
      end

      def edit
        @wholesaler = Spree::Wholesaler.find(params[:id])
        if @wholesaler.visible_address.nil?
          @wholesaler.visible_address = Spree::Address.default
        end
        respond_with(@wholesaler)
      end

      def update
        @wholesaler = Spree::Wholesaler.find(params[:id])

        if @wholesaler.update(wholesaler_params)
          flash[:notice] = I18n.t('spree.admin.wholesaler.update_success')
          respond_with(@wholesaler) do |format|
            format.html { redirect_to location_after_save }
            format.js { render layout: false }
          end
        else
          flash[:error] = I18n.t('spree.admin.wholesaler.update_failed')
          respond_with(@wholesaler)
        end
      end

      def destroy
        @wholesaler = Spree::Wholesaler.find(params[:id])
        @wholesaler.destroy
        flash[:success] = I18n.t('spree.admin.wholesaler.destroy_success')
        respond_with(@wholesaler) do |format|
          format.html { redirect_to collection_url }
          format.js  { render_js_for_destroy }
        end
      end

      def approve
        return redirect_to request.referer, :flash => { :error => "Wholesaler is already active." } if @wholesaler.active?
        @wholesaler.activate!
        redirect_to request.referer, :flash => { :notice => "Wholesaler was successfully approved." }
      end

      def reject
        return redirect_to request.referer, :flash => { :error => "Wholesaler is already rejected." } unless @wholesaler.active?
        @wholesaler.deactivate!
        redirect_to request.referer, :flash => { :notice => "Wholesaler was successfully rejected." }
      end

      def persist_user_address
        @wholesaler.user.bill_address_id = @wholesaler.billing_address_id
        @wholesaler.user.ship_address_id = @wholesaler.shipping_address_id
        @wholesaler.save
      end

      def export_csv(wholesalers)
        require 'csv'

        header = ['Store', 'Buyer', 'Email', 'Date of last order', 'Total sales (AUD)', 'Total sales (USD)', 'Total orders', 'Average order value (AUD)', 'Average order value (USD)', 'Phone number', 'Address1', 'City', 'State', 'Postcode', 'Country', 'Days since last order']

        CSV.generate(headers: true) do |csv|
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
      end

      private

      def get_reps
        @reps = Spree::User.reps
      end

      def approval_setup
        @wholesaler = Spree::Wholesaler.find(params[:id])
        @role = Spree::Role.find_or_create_by(name: 'wholesaler')
      end

      def collection
        return @collection if @collection.present?

        params[:search] ||= {}
        params[:search][:meta_sort] ||= "company.asc"
        @search = Spree::Wholesaler.ransack(params[:q])
        @collection = @search.result.page(params[:page]).per(params[:per_page] || Spree::Config[:admin_products_per_page])
      end

      def permitted_address_attributes
        [:firstname, :lastname, :company, :address1, :address2, :city, :state_id, :zipcode, :country_id, :phone, :id]
      end

      def wholesaler_params
        params.require(:wholesaler).
          permit(:ship_address, :bill_address, :company, :buyer,
            :terms, :phone, :website, :rep_id, :social, :comments, :use_billing, :faire, :visible, :visible_address_string,
            user_attributes: [:email, :password, :password_confirmation, :wholesale_user],
            bill_address_attributes: permitted_address_attributes,
            ship_address_attributes: permitted_address_attributes,
            visible_address_attributes: permitted_address_attributes)
      end
    end
  end
end
