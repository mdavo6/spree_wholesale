module Spree
  class WholesaleMailer < BaseMailer

    def new_wholesaler_email(wholesaler)
      @wholesaler = wholesaler
      subject = "New Wholesale Application Received: #{wholesaler.company}"
      mail(:to => "orders@example.com",
        :from => "noreply@example.com",
        :subject => subject)
    end

    def approve_wholesaler_email(wholesaler)
      @wholesaler = wholesaler
      subject = "Wholesale Account Approved for #{wholesaler.company}"
      mail(:to => wholesaler.email,
        :from => "noreply@example.com",
        :subject => subject)
    end
  end
end
