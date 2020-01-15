# frozen_string_literal: true

describe Pagemaster::Collection do
  include_context 'shared'
  before(:all) { Pagemaster::Test.reset }

  let(:csv_collection)  { site.collections.first }
  let(:json_collection) { site.collections[1] }
  let(:yaml_collection) { site.collections.last }

  describe '.new' do
    context 'with valid config' do
      it 'gets the source' do
        expect(csv_collection.source).to be_a String
      end

      it 'gets the id_key' do
        expect(csv_collection.id_key).to be_a String
      end
    end
  end

  describe '.ingest_source' do
    context 'with valid csv collection' do
      it 'ingests the source file' do
        result = csv_collection.ingest_source

        expect(result).to be_an Array
        expect(result.first).to be_a Hash
      end
    end

    context 'with valid json collection' do
      it 'ingests the source file' do
        result = json_collection.ingest_source

        expect(result).to be_an Array
        expect(result.first).to be_a Hash
      end
    end

    context 'with valid yaml collection' do
      it 'ingests the source file' do
        result = yaml_collection.ingest_source

        expect(result).to be_an Array
        expect(result.first).to be_a Hash
      end
    end
  end

  describe '.overwrite_pages' do
    context 'if page directory does not exists' do
      it 'does nothing' do
        expect { csv_collection.overwrite_pages }.not_to raise_error
      end
    end

    it 'removes the page directory' do
      csv_collection.overwrite_pages
    end
  end
end
