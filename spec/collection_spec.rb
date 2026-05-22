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

  describe '.apply_split' do
    context 'with split configuration' do
      let(:test_data) do
        [
          { 'pid' => 'item1', 'tags' => 't1;t2;t3' },
          { 'pid' => 'item2', 'tags' => 't4; t5 ;t6' },
          { 'pid' => 'item3', 'tags' => '' },
          { 'pid' => 'item4' }
        ]
      end

      before do
        csv_collection.instance_variable_set(:@data, test_data)
        csv_collection.apply_split
      end

      it 'splits values on the separator' do
        expect(test_data[0]['tags']).to eq(%w[t1 t2 t3])
      end

      it 'trims whitespace from each element' do
        expect(test_data[1]['tags']).to eq(%w[t4 t5 t6])
      end

      it 'skips empty values' do
        expect(test_data[2]['tags']).to eq('')
      end

      it 'skips missing keys' do
        expect(test_data[3].key?('tags')).to be false
      end

      it 'returns an array for non-empty values' do
        expect(test_data[0]['tags']).to be_an Array
      end
    end

    context 'without split configuration' do
      let(:yaml_collection) { site.collections.last }

      it 'does not modify data' do
        data = yaml_collection.ingest_source
        # Create a deep copy using Marshal
        original_data = Marshal.load(Marshal.dump(data))
        yaml_collection.instance_variable_set(:@data, data)

        yaml_collection.apply_split

        expect(yaml_collection.instance_variable_get(:@data)).to eq(original_data)
      end
    end
  end
end
