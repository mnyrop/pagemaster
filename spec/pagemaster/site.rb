# frozen_string_literal: true

describe Pagemaster::Site do
  include_context 'shared'
  before(:all) { Pagemaster::Test.reset }

  describe '.new' do
    it 'runs without errors' do
      expect(site).to be_a Pagemaster::Site
    end

    it 'parses the config' do
      expect(site.config).to be_a Hash
      expect(site.config).to eq config
    end

    it 'parses the args' do
      expect(site.args).to be_an Array
      expect(site.args).to eq args
    end

    it 'parses the opts' do
      expect(site.opts).to be_a Hash
      expect(site.opts). to eq opts
    end

    it 'parses the collections' do
      expect(site.collections).to be_an Array
      expect(site.collections.first).to be_a Pagemaster::Collection
    end

    context 'when given invalid args' do
      it 'throws an error' do
        expect { Pagemaster::Site.new(['bad_arg'], opts) }.to raise_error Pagemaster::Error::InvalidArgument
      end
    end
  end

  describe '.generate_pages' do
    it 'generates expected pages' do
      expect(site.generate_pages).to eq page_paths
    end
  end
end
