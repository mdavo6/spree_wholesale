module Spree
    module Admin 
        class TerritoriesController < Spree::Admin::BaseController
            respond_to :html
            before_action :load_user

            def new
                @user.country_id = current_store.default_country.id
            end

            def update
                @user.states = Spree::State.where(id: params[:user][:states].reject(&:empty?).map(&:to_i))
                @user.country = Spree::Country.find(params[:user][:country_id].to_i)
                if @user.save
                    flash[:success] = Spree.t('admin.user.territories.update_success')
                    respond_with(@user) do |format|
                        format.html { redirect_to spree.admin_user_territories_path(@user) }
                        format.js { render layout: false }
                    end
                else
                    flash[:error] = Spree.t('admin.user.territories.update_failed', error: e.message)
                end
            end

            def destroy
                @user.states.clear
                @user.country = nil
                if @user.save 
                    flash[:success] = Spree.t('admin.user.territories.destroy_success')
                    respond_with(@user) do |format|
                      format.html { redirect_to collection_url }
                      format.js  { }
                    end
                else
                    respond_with(@user) do |format|
                        format.html { render :edit, status: :unprocessable_entity }
                    end
                end
            end

            private

            def load_user
                @user = Spree.user_class.find_by(id: params[:user_id])

                unless @user
                flash[:error] = Spree.t(:user_not_found)
                redirect_to spree.admin_path
                end
            end

            def territory_params
              params.require(:user).permit(:country_id, states: [])
            end
        end
    end
end
