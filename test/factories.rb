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


  factory :wholesaler, :class => Spree::Wholesaler do
    company "Test Company"
    buyer_contact "Mr Contacter"
    manager_contact "Mr Manager"
    phone "555-555-5555"
    fax "555-555-5555 ext 1"
    resale_number "123456789"
    taxid "555-55-5555"
    web_address "testcompany.com"
    terms "Credit Card"
    notes "What a guy!"
    user { Factory.create(:wholesale_user) }
    bill_address { Factory.create(:address) }
    ship_address { Factory.create(:address) }
  end


  factory :user, :class => Spree::User do
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
    #wholesaler { Factory.create(:wholesaler) }
  end

  factory :order, :class => Spree::Order do
    user { Spree::User.last || Factory.create(:user) }
    state 'cart'
    payment_state 'balance_due'
    email { random_email }
    wholesale false
  end

  #factory :wholesale_order, :parent => :order do
  #  #user { Factory.create(:wholesale_user) }
  #  wholesale true
  #end

  factory :base_product, :class => Spree::Product do
    sequence(:name) { |n| "Product ##{n} - #{Kernel.rand(9999)}" }
    description { "Product description" }
    price 19.99
    cost_price 17.00
    sku 'ABC'
    available_on 1.year.ago
    deleted_at nil
  end

  factory :product, parent: :base_product do
    name 'RoR Mug'
  end

  factory :base_variant, :class => Spree::Variant do
    price 19.99
    cost_price 17.00
    sku    { SecureRandom.hex }
    weight { BigDecimal.new("#{rand(200)}.#{rand(99)}") }
    height { BigDecimal.new("#{rand(200)}.#{rand(99)}") }
    width  { BigDecimal.new("#{rand(200)}.#{rand(99)}") }
    depth  { BigDecimal.new("#{rand(200)}.#{rand(99)}") }

    # associations:
    product { |p| p.association(:base_product) }
  end

  factory :wholesale_variant, parent: :base_variant do
    wholesale_price 9.50
  end
end
