require 'spec_helper'

RSpec.describe Kurpelwoodworks::Repositories::NoteRepository do
  let(:input) {{ name: 'test name', description: 'long test description' }}
  let(:note) { subject.create!(input) }

  context "#find_by_id" do
    it "successfully" do
      expect(subject.find_by_id(note.id).name).to eq note.name
      expect(subject.find_by_id(note.id)).to be_a(Kurpelwoodworks::Entities::NoteEntity)
    end

    it "nil when record missing" do
      expect(subject.find_by_id(nil)).to be_falsy
    end

    let(:tag_repo) { Kurpelwoodworks::Repositories::TagRepository.new }
    let(:tag) { tag_repo.create!({ name: 'test_repo'}) }
    let(:input_with_tags) {{ name: 'test tag', description: 'test description', tags: [tag.name] }}
    let(:note_with_tags) { subject.create_with_tags!(input_with_tags) }

    it "with tags" do
      result = subject.find_by_id(note_with_tags.id, tags: true)

      expect(result).to be_truthy
      expect(result).to be_a(Kurpelwoodworks::Entities::NoteEntity)
      expect(result.tags.count).to eq(1)
      expect(result.tags[0]).to be_a(Kurpelwoodworks::Entities::TagEntity)
      expect(result.tags[0].name).to eq(tag.name)
    end

    it "nil when record missing with tags" do
      expect(subject.find_by_id(nil, tags: true)).to be_falsy
    end
  end

  context "#create!" do
    let(:result) { subject.create!(input) }

    it "successfully" do
      expect(result).to be_truthy
      expect(result).to be_a(Kurpelwoodworks::Entities::NoteEntity)
      expect(result.name).to eq(input[:name])
    end
  end

  context "create_with_tags!" do
    let(:tag_repo) { Kurpelwoodworks::Repositories::TagRepository.new }
    let(:tag) { tag_repo.create!({ name: 'test_repo'}) }
    let(:input) {{ name: 'test tag', description: 'test description', tags: [tag.name] }}
    let(:result) { subject.create_with_tags!(input) }

    it "successfully" do
      expect(result).to be_truthy
      expect(result).to be_a(Kurpelwoodworks::Entities::NoteEntity)
      expect(result.tags.count).to eq(1)
      expect(result.tags[0]).to be_a(Kurpelwoodworks::Entities::TagEntity)
      expect(result.tags[0].name).to eq(tag.name)
    end

    it "createa without tags" do
      result = subject.create_with_tags!(input.except(:tags))

      expect(result).to be_truthy
      expect(result).to be_a(Kurpelwoodworks::Entities::NoteEntity)
      expect(result.tags.count).to eq(0)
    end
  end

  context "#update!" do
    let(:update_input) {{ id: note.id, name: 'test name changed', description: 'long test description' }}
    let(:result) {
      subject.update!(update_input)
    }

    it "white existing note" do
      expect(result).to be_truthy
      expect(result).to be_a(Kurpelwoodworks::Entities::NoteEntity)
      expect(result.name).to eq('test name changed')
    end

    it "white missing note" do
      wrong_input = { id: 0, name: 'test name changed', description: 'long test description' }
      result = subject.update!(wrong_input)
      expect(result).to be_falsy
    end
  end

  context "#paginate" do
    it do
      subject.create!(input)
      subject.create!(input)
      subject.create!(input)
      subject.create!(input)

      expect(subject.count).to eq(4)
      expect(subject.paginate(0, 3).count).to eq(3)
    end
  end

  context "#count" do
    it do
      subject.create!(input)
      expect(subject.count).to eq(1)
    end
  end
end
