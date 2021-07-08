module Spree
  module UserDecorator

    def self.prepended(base)
      base.has_one :wholesaler, :class_name => "Spree::Wholesaler"
      base.before_create :generate_auth_token, if: :lead?
      base.before_save :delete_auth_token, unless: :lead?
      base.scope :wholesale, -> { includes(:spree_roles).where("spree_roles.name" => "wholesaler") }
      base.scope :lead, -> { includes(:spree_roles).where("spree_roles.name" => "lead") }
    end

    def wholesaler?
      has_spree_role?("wholesaler") && !wholesaler.nil?
    end

    def lead?
      has_spree_role?('lead')
    end

    def wholesaler_or_lead?
      wholesaler? || lead?
    end

    def contact_information_entered?
      wholesaler.present?
    end

    def has_address?
      addresses.present?
    end

    def permitted_wholesale_user?
      admin? || wholesaler_or_lead?
    end

    def application_completed?
      contact_information_entered? && has_address?
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
