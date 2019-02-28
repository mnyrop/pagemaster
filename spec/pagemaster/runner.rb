describe Pagemaster::Runner do
  include_context 'shared'
  before(:all)  { Pagemaster::Test.reset }

  describe '.new' do
    it 'runs without errors' do
      expect(runner).to be_a Pagemaster::Runner
    end

    it 'parses the config' do
      expect(runner.config).to be_a Hash
      expect(runner.config).to eq config
    end

    it 'parses the args' do
      expect(runner.args).to be_an Array
      expect(runner.args).to eq args
    end

    it 'parses the opts' do
      expect(runner.opts).to be_a Hash
      expect(runner.opts). to eq opts
    end

    it 'parses the collections' do
      expect(runner.collections).to be_an Array
      expect(runner.collections.first).to be_a Pagemaster::Collection
    end

    context 'when given incorrect args' do
      it 'throws an error' do
        expect { Pagemaster::Runner.new(['bad_arg'], opts) }.to raise_error Pagemaster::Error::InvalidArgument
      end
    end
  end
end
