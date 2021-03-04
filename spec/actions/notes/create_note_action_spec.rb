require 'spec_helper'

RSpec.describe Kurpelwoodworks::Actions::Notes::CreateNoteAction do
  let(:input) {{ name: 'long test name', description: 'long test description' }}
  let(:note_repo) { double("NoteRepository") }
  let(:note) {
    Kurpelwoodworks::Entities::NoteEntity.new(
      id: 1,
      name: "test name",
      description: "test description"
    )
  }

  before do
    allow(note_repo).to receive(:create!) { note }
  end

  subject { described_class.new(repository: note_repo) }

  context "#perform" do
    it "fail with invalid params" do
      expect(subject.perform({}).errors).not_to be_empty
    end

    it "create new action" do
      expect(subject.perform(input).errors).to be_empty
    end
  end
end
