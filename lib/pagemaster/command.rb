module Pagemaster
  class Command < Jekyll::Command
    def self.init_with_program(prog)
      prog.command(:pagemaster) do |c|
        c.syntax 'pagemaster [options] [args]'
        c.description 'Generate md pages from collection data.'
        c.option :no_perma, '--no-permalink', 'Skips adding hard-coded permalink.'
        c.option :force, '--force', 'Erases pre-existing collection before regenerating.'
        c.action do |args, options|
          pm = Pagemaster::Runner.new(args, options)
          pm.run
        end
      end
    end
  end
end
