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
      @source_dir       = @config['source' || '']
      @collections      = parse_collections
      @collections_dir  = @config['collections_dir']

      if @args.empty?
        raise Error::MissingArgs, 'You must specify one or more collections after `jekyll pagemaster`'
      end
      return unless @collections.empty?

      raise Error::InvalidCollection, "Cannot find collection(s) #{@args} in config"
    end

    #
    #
    def config_from_file
      YAML.load_file "#{`pwd`.strip}/_config.yml"
    end

    #
    #
    def parse_collections
      collections_config = @config['collections']

      if collections_config.nil?
        raise Error::InvalidConfig, "Cannot find 'collections' key in _config.yml"
      end

      args.map do |a|
        unless collections_config.key? a
          raise Error::InvalidArgument, "Cannot find requested collection #{a} in _config.yml"
        end

        Collection.new(a, collections_config.fetch(a), @source_dir)
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
