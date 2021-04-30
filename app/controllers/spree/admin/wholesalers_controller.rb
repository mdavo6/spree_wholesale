module Spree
  module Admin
    class WholesalersController < Spree::Admin::ResourceController
      respond_to :html, :xml
      before_action :approval_setup, :only => [ :approve, :reject ]
      after_action :persist_user_address, :only => [:create, :update]

      def index
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
          render :action => "new"
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

        if @wholesaler.update_attributes(wholesaler_params)
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

      private

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
            :terms, :phone, :website, :social, :comments, :use_billing, :visible, :visible_address_string,
            user_attributes: [:email, :password, :password_confirmation, :wholesale_user],
            bill_address_attributes: permitted_address_attributes,
            ship_address_attributes: permitted_address_attributes,
            visible_address_attributes: permitted_address_attributes)
      end
    end
  end
end
