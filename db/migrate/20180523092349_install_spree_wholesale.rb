class InstallSpreeWholesale < ActiveRecord::Migration

  def self.up
    create_table :spree_wholesalers do |t|
      t.references :user
      t.integer :billing_address_id
      t.integer :shipping_address_id
      t.string :company
      t.string :buyer
      t.string :phone
      t.string :website
      t.string :social
      t.string :terms, default: 'advance'
      t.text   :comments
      t.timestamps
    end
    add_index :spree_wholesalers, [:billing_address_id, :shipping_address_id], :name => "wholesalers_addresses"
    add_column :spree_orders,             :wholesale,       :boolean, default: false
    add_column :spree_prices,             :wholesale,       :boolean, default: false
    add_column :spree_shipping_methods,   :wholesale,       :boolean, default: false
    add_column :spree_users,              :wholesale_user,  :boolean, default: false
  end

  def self.down
    remove_column :spree_orders,            :wholesale
    remove_column :spree_prices,            :wholesale
    remove_column :spree_shipping_methods,  :wholesale
    remove_column :spree_users,             :wholesale_user
    drop_table :spree_wholesalers
  end

end
