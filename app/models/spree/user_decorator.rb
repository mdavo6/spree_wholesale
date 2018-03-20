Spree::User.class_eval do
  has_one :wholesaler, :class_name => "Spree::Wholesaler"

  scope :wholesale, -> { includes(:spree_roles).where("spree_roles.name" => "wholesaler") }

  def wholesaler?
    has_spree_role?("wholesaler") && !wholesaler.nil?
  end

end
