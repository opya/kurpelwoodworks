require 'pagy'
require 'pagy/extras/metadata'

module Kurpelwoodworks
  class Router
    include Import[
      list_action: 'actions.notes.list_notes_action',
      show_action: 'actions.notes.show_note_action',
      create_action: 'actions.notes.create_note_action',
      update_action: 'actions.notes.update_note_action'
    ]

    include Pagy::Backend

    hash_branch 'notes' do |r|
      # route[records_create]: GET|POST /records
      r.is do
        r.get do
          data = list_action.perform(request.params["page"]).to_h
          data[:paginator] = pagy_metadata(data[:paginator])
          data
        end

        r.post do
          name = r.params["name"]
          description = r.params["description"]

          create_action.perform(name, description).to_h
        end
      end

      # route[records_view_edit]: GET|POST /records/:record_id
      r.on Integer do |id|
        r.is do
          r.get do
            show_action.perform(id).to_h
          end

          r.post do
            name = r.params["name"]
            description = r.params["description"]

            update_action.perform(id, name, description).to_h
          end
        end
      end

      # route[records_search]: GET|POST /records/search
      r.is 'search' do
        r.get do
          view("records/search_form")
        end

        r.post String do |search_term|
          binding.pry
        end
      end

    end
  end
end
