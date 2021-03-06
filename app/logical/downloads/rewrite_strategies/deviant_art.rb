module Downloads
  module RewriteStrategies
    class DeviantArt < Base
      attr_accessor :url, :source

      def initialize(url)
        @url  = url
      end

      def rewrite(url, headers, data = {})
        if url =~ /https?:\/\/(?:.+?\.)?deviantart\.(?:com|net)/
          url, headers = rewrite_html_pages(url, headers)
          url, headers = rewrite_thumbnails(url, headers)
          data[:artist_commentary_title] = source.artist_commentary_title
          data[:artist_commentary_desc] = source.artist_commentary_desc
        end

        return [url, headers, data]
      end

    protected
      def rewrite_html_pages(url, headers)
        if url =~ %r{^https?://.+?\.deviantart\.com/art/}
          return [source.image_url, headers]
        else
          return [url, headers]
        end
      end

      def rewrite_thumbnails(url, headers)
        if url =~ %r{^(https?://(?:fc|th)\d{2}\.deviantart\.net/.+?/)200H/}
          match = $1
          url.sub!(match + "200H/", match)
        elsif url =~ %r{^(https?://(?:fc|th)\d{2}\.deviantart\.net/.+?/)PRE/}
          match = $1
          url.sub!(match + "PRE/", match)
        elsif url =~ %r{^https?://(?:pre|img)\d{2}\.deviantart\.net/}
          return [source.image_url, headers]
        end

        return [url, headers]
      end

      # Cache the source data so it gets fetched at most once.
      def source
        @source ||= begin
          source = ::Sources::Strategies::DeviantArt.new(url)
          source.get

          source
        end
      end
    end
  end
end
