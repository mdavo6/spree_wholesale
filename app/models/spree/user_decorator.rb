module Spree
  module UserDecorator

    def self.prepended(base)
      base.has_one :wholesaler, :class_name => "Spree::Wholesaler"
    end

    before_create :generate_auth_token, if: :lead?
    before_save :delete_auth_token, unless: :lead?

    scope :wholesale, -> { includes(:spree_roles).where("spree_roles.name" => "wholesaler") }
    scope :lead, -> { includes(:spree_roles).where("spree_roles.name" => "lead") }

    def wholesaler?
      has_spree_role?("wholesaler") && !wholesaler.nil?
    end

    def lead?
      has_spree_role?('lead')
    end

    def wholesaler_or_lead?
      wholesaler? || lead?
    end

    protected

    def generate_auth_token
      self.authentication_token = Devise.friendly_token
    end

    def delete_auth_token
      self.authentication_token = nil
    end

  end
end

::Spree::User.prepend(Spree::UserDecorator)
