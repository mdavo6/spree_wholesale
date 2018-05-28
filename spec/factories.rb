FactoryBot.define do

  factory :state, :class => Spree::State do
    name "California"
    abbr "CA"
    country { Spree::Country.find_by_iso("US") || Factory.create(:country) }
  end

  factory :country, :class => Spree::Country do
    name "United States"
    iso3 "USA"
    iso "US"
    iso_name { name.upcase }
    numcode 840
  end

  factory :wholesaler_user, class: Spree::User do
    first_name: "First"
    email { random_email }
    password "spree123"
    password_confirmation "spree123"
    spree_roles { [Spree::Role.find_or_create_by_name("user")] }
  end

  factory :admin_user, :parent => :user do
    spree_roles { [Spree::Role.find_or_create_by_name("admin")] }
  end

  factory :wholesale_user, :parent => :user do
    spree_roles { [Spree::Role.find_or_create_by_name("wholesaler")] }
  end

  factory :wholesaler, :class => Spree::Wholesaler do
    company "Test Company"
    buyer "Mr Contacter"
    phone "555-555-5555"
    website "testcompany.com"
    social "@testcompany"
    terms "Advance"
    comments "What a guy!"
    user { Factory.create(:wholesale_user) }
    bill_address { Factory.create(:address) }
    ship_address { Factory.create(:address) }
  end

  factory :address, :class => Spree::Address do
    firstname "Addy"
    lastname "Streetston"
    address1 { "#{100 + rand(1000)} State St" }
    city "Santa Barbara"
    phone "555-555-5555"
    zipcode "93101"
    state { Spree::State.find_by_name("California") || Factory.create(:state) }
    country { Spree::Country.find_by_name("United States") || Factory.create(:country) }
  end

  # factory :gift_card_payment_method, class: Spree::PaymentMethod::GiftCard do
  #   type "Spree::PaymentMethod::GiftCard"
  #   name "Gift Card"
  #   description "Gift Card"
  #   active true
  #   auto_capture false
  # end
  #
  # factory :gift_card_payment, class: Spree::Payment, parent: :payment do
  #   association(:payment_method, factory: :gift_card_payment_method)
  #   association(:source, factory: :gift_card)
  # end
  #
  # factory :gift_card_store_credit_category, class: Spree::StoreCreditCategory, parent: :store_credit_category do
  #   name "Gift Card"
  # end
  #
  # factory :gift_card_transaction, class: Spree::GiftCardTransaction do
  #   gift_card
  #   action             { Spree::GiftCard::AUTHORIZE_ACTION }
  #   amount             { 100.00 }
  #   authorization_code { "#{gift_card.id}-SC-20140602164814476128" }
  # end
end
