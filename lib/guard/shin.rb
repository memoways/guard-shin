require "guard"
require "guard/plugin"

require "shin/compiler"
require "benchmark"

module Guard
  class Shin < Plugin

    # Initializes a Guard plugin.
    # Don't do any work here, especially as Guard plugins get initialized even if they are not in an active group!
    #
    # @param [Hash] options the custom Guard plugin options
    # @option options [Array<Guard::Watcher>] watchers the Guard plugin file watchers
    # @option options [Symbol] group the group this Guard plugin belongs to
    # @option options [Boolean] any_return allow any object to be returned from a watcher
    #
    def initialize(options = {})
      super
      @options = options
      puts "Shin: initialized!"
    end

    def start
      puts "Shin: start!"
    end

    def stop
      puts "Shin: stop!"
    end

    def run_all
      path = @options[:main]
      puts "Compiling #{path}..."
      ms = Benchmark.realtime do
        compiler.compile(File.read(path), :file => path)
      end
      puts "[Shin] #{path} compiled in #{(1000 * ms).round(0)}ms"
    end

    private

    def compiler
      @compiler ||= ::Shin::Compiler.new(@options)
    end

  end
end
