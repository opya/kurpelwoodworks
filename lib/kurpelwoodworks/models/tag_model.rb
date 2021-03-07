require 'kurpelwoodworks/models/note_model'

module Kurpelwoodworks
  module Models
    class TagModel < Sequel::Model(:tags)
      many_to_many :notes, left_key: :tag_id, right_key: :note_id, join_table: :notes_tags, class: "Kurpelwoodworks::Models::NoteModel"
    end
  end
end
