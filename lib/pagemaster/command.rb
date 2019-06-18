# frozen_string_literal: true

module Pagemaster
  #
  #
  class Command < Jekyll::Command
    def self.init_with_program(prog)
      prog.command(:pagemaster) do |c|
        c.syntax 'pagemaster [options] [args]'
        c.description 'Generate md pages from collection data.'
        c.option :force, '--force', 'Erases pre-existing collection before regenerating.'
        c.action do |args, options|
          site = Pagemaster::Site.new args, options
          site.generate_pages
        end
      end
    end
  end
end
