require 'csv'

def slug(str)
  str.downcase.tr(' ', '_').gsub(/[^\w-]/, '')
end

def write_csv(path, hashes)
  CSV.open(path, 'wb:UTF-8') do |csv|
    csv << hashes.first.keys
    hashes.each do |hash|
      csv << hash.values
    end
  end
rescue StandardError
  abort "Cannot write csv data to #{path} for some reason."
end

def add_collections_to_config(args, collection_data)
  collection_hash = {}
  args.each do |name|
    collection_hash[name] = {
      'source' => name + collection_data[name]['type'],
      'id_key' => 'pid',
      'layout' => 'iiif-image-page'
    }
  end
  config = YAML.load_file('_config.yml')
  config['collections'] = collection_hash
  output = YAML.dump config
  File.write('_config.yml', output)
end
