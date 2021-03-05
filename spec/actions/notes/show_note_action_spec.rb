require 'spec_helper'

RSpec.describe Kurpelwoodworks::Actions::Notes::ShowNoteAction do
  let(:note_repo) { double("NoteRepository") }
  let(:note) {
    Kurpelwoodworks::Entities::NoteEntity.new(
      id: 1,
      name: "test name",
      description: "test description"
    )
  }

  subject { described_class.new(repository: note_repo) }

  context "#perform" do
    it "with existing record" do
      allow(note_repo).to receive(:find_by_id) { note }
      result = subject.perform(note.id)
      expect(result).to be_a(Dry::Monads::Success)
      expect(result.value![:note][:id]).to eq(1)
    end

    it "null id" do
      expect(note_repo).to receive(:find_by_id) { nil }
      result = subject.perform(nil)
      expect(result).to be_a(Dry::Monads::Failure)
      expect(result.failure).to be_truthy
    end
  end
end
