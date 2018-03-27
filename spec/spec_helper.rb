include FileUtils

require 'fake/helpers'
require 'fake/site'
require 'fake/data'

$LOAD_PATH.unshift File.expand_path('../lib', __dir__)
require 'pagemaster'

describe 'pagemaster' do
  Fake.site
  collection_data = Fake.data
  args = collection_data.map { |c| c[0] }
  add_collections_to_config(args, collection_data)
  dirs = args.map { |a| '_' + a }

  it 'throws no errors' do
    Pagemaster.execute(args)
  end

  it 'makes the correct dirs' do
    dirs.each { |dir| expect(exist(dir)) }
  end

  it 'generates md pages' do
    dirs.each { |dir| expect(Dir.glob(dir + '/*.md')) }
  end
end
