module Spree
  module UserDecorator

    def self.prepended(base)
      base.include Spree::TotalReporting
      base.has_one :wholesaler, :class_name => "Spree::Wholesaler"
      base.before_create :generate_auth_token, if: :lead?
      base.before_save :delete_auth_token, unless: :lead?
      base.scope :wholesale, -> { includes(:spree_roles).where("spree_roles.name" => "wholesaler") }
      base.scope :lead, -> { includes(:spree_roles).where("spree_roles.name" => "lead") }
      base.scope :wholesale_or_applicant, -> { includes(:spree_roles).where("spree_roles.name" => ["wholesaler", "applicant"]) }
    end

    def has_spree_role_old?(role_in_question)
      spree_roles.any? { |role| role.name == role_in_question.to_s }
    end

    def rep?
      has_spree_role_old?('rep')
    end

    def wholesaler?
      has_spree_role_old?("wholesaler") && !wholesaler.nil?
    end

    def lead?
      has_spree_role_old?('lead')
    end

    def applicant?
      has_spree_role_old?('applicant')
    end

    def wholesaler_or_lead?
      wholesaler? || lead?
    end

    def wholesaler_or_applicant?
      wholesaler? || applicant?
    end

    def contact_information_entered?
      wholesaler.present?
    end

    def has_address?
      addresses.present?
    end
    
    def has_store_address?
      if has_address?
        addresses.each do |address|
          return true if address.store
        end
      end
      false
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
