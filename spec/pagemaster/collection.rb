# frozen_string_literal: true

describe Pagemaster::Collection do
  include_context 'shared'
  before(:all) { Pagemaster::Test.reset }

  describe '.new' do
    let(:collection) { site.collections.first }

    it 'gets the source' do
      expect(collection.source).to be_a(String)
    end

    it 'gets the id_key' do
      expect(collection.id_key).to be_a(String)
    end
  end
end
