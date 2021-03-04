require 'spec_helper'

RSpec.describe Kurpelwoodworks::Actions::Notes::ListNotesAction do
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
    it "valid" do
      allow(note_repo).to receive(:count) { 1 }
      allow(note_repo).to receive(:paginate) { [note] }
      result = subject.perform(1)
      expect(result).to be_truthy
      expect(result.errors).to be_empty
      expect(result.notes.count).to eq 1
    end

    it "invalid" do
      allow(note_repo).to receive(:count) { 1 }
      allow(note_repo).to receive(:paginate) { [note] }
      result = subject.perform(:bad_page)
      expect(result.errors).not_to be_empty
    end
  end
end
