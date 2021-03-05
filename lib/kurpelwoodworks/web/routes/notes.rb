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
          action = list_action.perform(r.params["page"] || 1)

          if action.success?
            data = action.value!
            data[:paginator] = pagy_metadata(data[:paginator])
            data
          else
            response.status = 400
            action.failure
          end
        end

        r.post do
          action = create_action.perform(r.params)

          if action.success?
            action.value!
          else
            response.status = 400
            action.failure
          end
        end
      end

      # route[records_view_edit]: GET|POST /records/:record_id
      r.on Integer do |id|
        r.is do
          r.get do
            action = show_action.perform(id)

            if action.success?
              action.value! 
            else
              response.status = 400
              action.failure
            end
          end

          r.post do
            action = update_action.perform(r.params.merge({id: id}))

            if action.success?
              action.value! 
            else
              response.status = 400
              action.failure
            end
          end
        end
      end

    end
  end
end
