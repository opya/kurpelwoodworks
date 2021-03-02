require 'pagy'
require 'pagy/extras/metadata'
require 'actions/records/create_note_action'
require 'actions/records/update_note_action'
require 'actions/records/list_notes_action'
require 'actions/records/show_note_action'

module Kurpelwoodworks
  class Router
    include Pagy::Backend

    hash_branch 'notes' do |r|
      # route[records_create]: GET|POST /records
      r.is do
        r.get do
          data = ListNotesAction.build.perform(request.params["page"]).to_h
          data[:paginator] = pagy_metadata(data[:paginator])
          data
        end

        r.post do
          name = r.params["name"]
          description = r.params["description"]

          CreateNoteAction.build.perform(name, description).to_h
        end
      end

      # route[records_view_edit]: GET|POST /records/:record_id
      r.on Integer do |id|
        r.is do
          r.get do
            ShowNoteAction.build.perform(id).to_h
          end

          r.post do
            name = r.params["name"]
            description = r.params["description"]

            UpdateNoteAction.build.perform(id, name, description).to_h
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
