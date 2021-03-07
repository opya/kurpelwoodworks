require 'kurpelwoodworks/models/tag_model'

module Kurpelwoodworks
  module Models
    class NoteModel < Sequel::Model(:notes)
      many_to_many :tags, left_key: :note_id, right_key: :tag_id, join_table: :notes_tags, class: "Kurpelwoodworks::Models::TagModel"
    end
  end
end
