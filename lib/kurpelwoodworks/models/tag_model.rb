require 'kurpelwoodworks/models/note_model'

module Kurpelwoodworks
  module Models
    class TagModel < Sequel::Model(:tags)
      many_to_many :notes, left_key: :note_id, right_key: :tag_id, join_table: :notes_tags, class: 'NoteModel' 
    end
  end
end
