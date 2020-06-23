require 'mail'

class MMail
  TO = "s.angelov@kurpelwoodworks.com".freeze
  FROM = "contact_form@kurpelwoodworks.com".freeze
  BODY = <<-BODY
    Име: %s
    Email: %s
    Телефон: %s
    Събщение: %s
  BODY

  PHONE_REGEX = /^([+]?359)|0?(|-| )8[789]\d{1}(|-| )\d{3}(|-| )\d{3}$/

  def initialize(name, email, phone, message)
    @name = name
    @email = email
    @phone = phone
    @message = message
  end

  def valid?
    return false if @name.length == 0
    return false if @email.length == 0 && @phone.length == 0

    if @email.length != 0
      return false if (@email =~ URI::MailTo::EMAIL_REGEXP).nil?
    end

    if @phone.length != 0
      return false if (@phone =~ PHONE_REGEX).nil?
    end

    return false if @message.length == 0

    return true
  end

  def new_contact_form_message
    _mail_config

    name = @name
    email = @email
    phone = @phone
    message = @message

    _subject = 'Ново запитване от контактната форма'
    _subject = 'Лоши данни от контактната форма.' unless valid?

    Mail.deliver do
      from      FROM 
      to        TO 
      subject   _subject 
      body      sprintf(BODY, name, email, phone, message)
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
