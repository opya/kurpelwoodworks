require_relative '../entities/mmail'

class Kurpelwoodworks
  hash_branch 'contacts' do |r|
    r.post do
      contact = r.params["contact"]

      m = MMail.new(
        contact["name"],
        contact["email"],
        contact["phone"],
        contact["message"]
      )
      m.new_contact_form_message

      @sent = m.valid? ? true : false

      view("contacts")
    end

    r.get do
      view("contacts")
    end
  end
end
