require 'spec_helper'

RSpec.describe Kurpelwoodworks::Repositories::TagRepository do
  let(:tag_input) {{ name: 'test tag name' }}

  describe "#create!" do
    let(:result) { subject.create!(tag_input) }

    it "new tag" do
      expect(result).to be_truthy
      expect(result).to be_a(Kurpelwoodworks::Entities::TagEntity)
    end
  end

  describe "#find_or_create_by_name!" do
    it "find" do
      tag = subject.create!(tag_input)
      result = subject.find_or_create_by_name!(tag.name)

      expect(result).to be_truthy
      expect(result).to be_a(Kurpelwoodworks::Entities::TagEntity)
    end

    it "create" do
      expect(subject.find_by_name(tag_input[:name])).to be_falsy

      result = subject.find_or_create_by_name!(tag_input[:name])

      expect(result).to be_truthy
      expect(result).to be_a(Kurpelwoodworks::Entities::TagEntity)
      expect(subject.find_by_name(tag_input[:name])).to be_truthy
    end
  end

  describe "#find_by_name" do
    it "successfully" do
      tag = subject.create!(tag_input)
      result = subject.find_by_name(tag.name)

      expect(result).to be_truthy
      expect(result).to be_a(Kurpelwoodworks::Entities::TagEntity)
    end

    it "fails" do
      result = subject.find_by_name("unexisting_tag_name")

      expect(result).to be_falsy
    end
  end

end
