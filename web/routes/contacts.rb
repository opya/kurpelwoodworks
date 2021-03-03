require 'lib/mmail'

class Router
  hash_branch 'contacts' do |r|
    check_csrf!

    # route[contacts_create]: POST /contacts
    r.post do
      sent = false

      if r.params.key? "contact"
        contact = r.params["contact"]

        m = MMail.new(
          contact["name"],
          contact["email"],
          contact["phone"],
          contact["message"]
        )
        m.new_contact_form_message

        sent = m.valid? ? true : false
        #@sent = m.valid? ? true : false
        #view("contacts")
      end

      { mail: {sent: sent } }
    end

    # route[contacts_index]: GET /contacts
    r.get do
      view("contacts")
    end
  end
end
