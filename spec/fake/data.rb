require 'csv'
require 'faker'
require 'json'
require 'yaml'

module Fake
  def self.data
    collection_data = {}
    ['.csv', '.json', '.yml'].each do |i|
      name = slug(Faker::RuPaul.unique.queen)
      data = generate_data(name, i, collection_data)
      path = '_data/' + name + i
      case i
      when '.csv' then write_csv(path, data)
      when '.json' then File.open(path, 'w') { |f| f.write(data.to_json) }
      when '.yml' then File.open(path, 'w') { |f| f.write(data.to_yaml) }
      end
      puts "Writing #{i} data to #{path}."
      Faker::Dune.unique.clear
      Faker::Lovecraft.unique.clear
    end
    collection_data
  end

  def self.generate_data(name, type, collection_data)
    data = []
    keys = ['pid']
    5.times { keys << slug(Faker::Lovecraft.unique.word) } # keys = pid + 5
    5.times do # with 5 records
      record = {
        keys[0] => slug(Faker::Dune.unique.character),
        keys[1] => Faker::Lorem.sentence,
        keys[2] => Faker::TwinPeaks.quote,
        keys[3] => Faker::Name.name,
        keys[4] => Faker::Space.star,
        keys[5] => Faker::Lovecraft.sentence
      }
      data << record
      collection_data[name] = { 'keys' => keys, 'type' => type }
    end
    data
  end
end
