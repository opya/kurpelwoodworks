require 'spec_helper'

RSpec.describe Kurpelwoodworks::Validations::NoteValidation do
  context 'invalid' do
    it 'when name missing' do
      missing_name_input = {description: 'long test description'}
      expect(subject.call(missing_name_input)).to be_failure
      expect(subject.call(missing_name_input).errors.to_h).to include(:name)
    end

    it 'when name.length < 10' do
      short_name_input = {name: 'test', description: 'long test description'}
      expect(subject.call(short_name_input)).to be_failure
      expect(subject.call(short_name_input).errors.to_h).to include(:name)
    end

    it 'when name.length > 150' do
      short_name_input = {name: "test"*150, description: 'long test description'}
      expect(subject.call(short_name_input)).to be_failure
      expect(subject.call(short_name_input).errors.to_h).to include(:name)
    end

    it 'when description missing' do
      missing_description_input = {name: 'test name'}
      expect(subject.call(missing_description_input)).to be_failure
      expect(subject.call(missing_description_input).errors.to_h).to include(:description)
    end

    it 'when description.length < 20' do
      short_description_input = {description: 'short description'}
      expect(subject.call(short_description_input)).to be_failure
      expect(subject.call(short_description_input).errors.to_h).to include(:description)
    end

    it 'when tags != array' do
      invalid_tags_input = {tags: 1}
      expect(subject.call(invalid_tags_input)).to be_failure
      expect(subject.call(invalid_tags_input).errors.to_h).to include(:tags)
    end
  end

  context 'valid' do
    it do
      input = {name: 'test name', description: 'wont test description'}
      expect(subject.call(input)).to be_truthy
    end

    it 'with array of tags' do
      input = {name: 'test name', description: 'wont test description', tags: []}
      expect(subject.call(input)).to be_truthy
    end
  end

end
