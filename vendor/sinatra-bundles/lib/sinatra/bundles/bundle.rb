module Sinatra
  module Bundles
    # The base class for a bundle of files.
    # The developer user sinatra-bundles should
    # never have to deal with this directly
    class Bundle
      def initialize(app, files)
        @app = app
        @files = files
      end

      # Since we pass Bundles back as the body,
      # this follows Rack standards and supports an each method
      # to yield parts of the body, in our case, the files.
      def each
        @files.each do |f|
          content = File.read(path(f))
          content = compress(content) if @app.compress_bundles
          # Include a new line to prevent weirdness at file boundaries
          yield("#{content}\n")
        end
      end

    private

      # The timestamp of the bundle, which is the newest file in the bundle.
      #
      # @return [Integer] The timestamp of the bundle
      def stamp
        @files.map do |f|
          File.mtime(path(f))
        end.sort.first.to_i
      end
    end
  end
end