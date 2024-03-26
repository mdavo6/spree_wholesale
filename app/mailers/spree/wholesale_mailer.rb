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

    def csv_export_email(csv_file, current_user)
      attachments['wholesalers.csv'] = csv_file
      subject = "Wholesalers CSV Export"
      mail(:to => current_user.email,
      :from => 'wholesale@boldb.com.au',
      :subject => subject)
  end
end
