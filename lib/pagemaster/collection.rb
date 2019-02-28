module Pagemaster
  class Collection
    attr_reader :source, :id_key, :layout

    def initialize(collection_config)
      @source = collection_config.dig('source')
      @id_key = collection_config.dig('id_key')
      @layout = collection_config.dig('layout')
    end
  end
end
