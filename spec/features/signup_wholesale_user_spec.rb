RSpec.feature 'Sign Up', type: :feature do

  context 'with valid data' do
    scenario 'create a new wholesale user' do
      visit spree.signup_path(wholesale_user: true)

      fill_in 'Email', with: 'email@person.com'
      fill_in 'Password', with: 'password'
      fill_in 'Password Confirmation', with: 'password'
      click_button 'Create'

      expect(page).to have_text 'You have signed up successfully.'
      expect(Spree::User.count).to eq(1)
      expect(Spree::User.first.wholesale_user).to eq(true)
    end
  end

  context 'with invalid data' do
    scenario 'fail first then successfully create a new wholesale_user' do
      visit spree.signup_path(wholesale_user: true)

      fill_in 'Email', with: 'email@person.com'
      fill_in 'Password', with: 'password'
      fill_in 'Password Confirmation', with: ''
      click_button 'Create'

      expect(page).to have_css '#errorExplanation'
      expect(Spree::User.count).to eq(0)

      fill_in 'Email', with: 'email@person.com'
      fill_in 'Password', with: 'password'
      fill_in 'Password Confirmation', with: 'password'
      click_button 'Create'

      expect(page).to have_text 'You have signed up successfully.'
      expect(Spree::User.count).to eq(1)
      expect(Spree::User.first.wholesale_user).to eq(true)
    end
  end
end
