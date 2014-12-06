require "guard"
require "guard/plugin"
require "guard/watcher"

require "shin/compiler"
require "benchmark"

module Guard
  class Shin < Plugin
    require "shin/cli"

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

      options[:sourcepath].each do |path|
        watchers << ::Guard::Watcher.new(%r{^#{ path }(.*\.clj(s?))$})
      end
      puts "Shin: initialized!"
    end

    def start
      run_all
    end

    def run_all
      run_on_changes files.reject {|f| macro?(f)}
    end

    def run_on_changes(paths)
      paths.each do |path|
        if path.downcase.end_with?('.clj')
          puts "[Shin] Ignoring #{path} change since it's a macro module :(".brown
          next
        end

        success = false
        ms = Benchmark.realtime do
          begin
            compiler.compile(File.read(path), :file => path)
            success = true
          rescue ::Shin::SyntaxError => e
            puts "[Shin] SyntaxError: #{e.message}".red
          rescue => e
            puts "[Shin] Error: #{e.message}".red
            puts e.backtrace
          end
        end
        puts "[Shin] Compiled #{path} in #{(1000 * ms).round(0)}ms".green if success
      end
    end

    private

    def macro?(path)
      File.basename(path).downcase.end_with? '.clj'
    end

    def files
      Watcher.match_files(self, Dir.glob('{,**/}*{,.clj(s?)}').uniq)
    end

    def compiler
      @compiler ||= ::Shin::Compiler.new(@options)
    end

  end
end

