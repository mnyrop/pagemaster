# frozen_string_literal: true

module Pagemaster
  #
  #
  class Site
    attr_reader :config, :args, :opts, :collections

    #
    #
    def initialize(args, opts, config = nil)
      @args             = args
      @opts             = opts
      @config           = config || config_from_file
      @collections      = parse_collections
      @collections_dir  = @config.dig 'collections_dir'
      @source_dir       = @config.dig 'source_dir'

      raise Error::MissingArgs, 'You must specify one or more collections after `jekyll pagemaster`' if @args.empty?
      raise Error::InvalidCollection, "Cannot find collection(s) #{@args} in config" if @collections.empty?
    end

    #
    #
    def config_from_file
      YAML.load_file "#{`pwd`.strip}/_config.yml"
    end

    #
    #
    def parse_collections
      collections_config = @config.dig 'collections'

      raise Error::InvalidConfig, "Cannot find 'collections' key in _config.yml" if collections_config.nil?

      args.map do |a|
        raise Error::InvalidArgument, "Cannot find requested collection #{a} in _config.yml" unless collections_config.key? a

        Collection.new(a, collections_config.fetch(a))
      end
    end

    #
    #
    def generate_pages
      paths = @collections.map do |c|
        c.generate_pages @opts, @collections_dir, @source_dir
      end.flatten
      puts Rainbow('Done ✔').green

      paths
    end
  end
end
