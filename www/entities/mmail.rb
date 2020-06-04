require 'mail'

class MMail
  TO = "s.angelov@kurpelwoodworks.com".freeze
  FROM = "contact_form@kurpelwoodworks.com".freeze
  BODY = <<-BODY
    Email: %s
    Име: %s
    Събщение: %s
  BODY

  class << self
    def new_contact_form_message(email, name, message)
      _mail_config

      Mail.deliver do
        from      FROM 
        to        TO 
        subject   'Ново запитване от контактната форма'
        body      sprintf(BODY, email, name, message)
      end
    end

    private

    def _mail_config
      if ENV["production"]
        Mail.defaults do
          delivery_method :sendmail
        end
      else
        require "letter_opener"

        location = File.expand_path('/tmp/letter_opener', __FILE__)

        Mail.defaults do
          delivery_method LetterOpener::DeliveryMethod, location: location
        end
      end
    end
  end

end
