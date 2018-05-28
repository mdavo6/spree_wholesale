RSpec.feature 'Variant Prices', :js do
  stub_authorization!

  given!(:product) { create(:product) }

  context 'with USD, AUD and EUR as currencies' do
    background do
      reset_spree_preferences do |config|
        config.supported_currencies = 'USD,AUD,EUR'
      end
    end

    scenario 'allows to save a retail and wholesale price for each currency' do
      visit spree.admin_product_path(product)
      click_link 'Prices'
      expect(page).to have_content 'USD'
      expect(page).to have_content 'AUD'
      expect(page).to have_content 'EUR'

      fill_in "vp_#{product.master.id}_USD_false", with: '20.00'
      fill_in "vp_#{product.master.id}_AUD_false", with: '24.00'
      fill_in "vp_#{product.master.id}_EUR_false", with: '16.00'

      fill_in "vp_#{product.master.id}_USD_true", with: '10.00'
      fill_in "vp_#{product.master.id}_AUD_true", with: '12.00'
      fill_in "vp_#{product.master.id}_EUR_true", with: '8.00'

      click_button 'Update'
      expect(page).to have_content 'Prices successfully saved'
    end
  end
end
