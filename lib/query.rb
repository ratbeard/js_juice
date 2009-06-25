#stdlib
require 'ostruct'
require 'uri'
require 'net/http'

# gems
begin
  require 'hpricot'
rescue LoadError
  require 'rubygems'
  require 'hpricot' 
end

# mine


module JsJuice
  
  module Query  
    
    # The result from a Library Query:
    class Result < OpenStruct
       # TODO justify text!
       def formated
         "#{name}     |  #{versions.reverse.join(", ")}"
       end

       # TODO
       def download(opts={})   
         require 'download'
         opts[:version] ||= latest_version
         # ...
       end

       # TODO
       def url(opts={})
         opts.empty?? path :  construct_url(opts)
       end

       def has_uncompressed?
         !! respond_to?("path(u)")
       end

       def latest
         versions.first
       end
                               
       private
       def construct_url(opts)
         defaults = { :version => latest, :uncompressed => false}
         defaults.merge!(opts)
         check_version_available(opts[:version])
         check_uncompressed_available if opts[:uncompressed]
         
       end 
       
       def check_version_available(version)
         if not versions.include? version
           raise "#{name} doesn't have version: #{version}.  available versions: #{versions}"                             
         end
         true
       end
       
       def check_uncompressed_available
         if not uncompressed?
           raise "#{name} doesn't support uncompressed"                             
         end
         true
       end
       
       
     end
                                       
    # Query Google about the libraries it provides w/ this class
    class Google
      def info_url 
        "http://code.google.com/apis/ajaxlibs/documentation/"
      end
      
      # Get library info by name
      def [](lib_name)
        libs.find {|l| l.name == lib_name} || raise("Couldn't find library #{lib_name}")
      end
      
      # Get list of Libraries.  memoized
      def libs
        @libs ||=
          library_info_elements.map do |el| 
            Result.new(extract_lib_info(el))                
          end
      end                                

      # just the library names
      def names
        libs.map {|l| l.name }
      end
      
      # html page.  memoized
      def fetch
        @response ||= Net::HTTP.get_response(URI.parse(info_url)).body
      end
      
      private                                                            
      # hpricot doc of html body.  memoized
      def doc
        @doc ||= Hpricot(fetch)
      end
      
      # html elements with library info
      def library_info_elements
        doc / 'dl.al-liblist'
      end

      # convert an [] of elems to a hash of props
      # calling inner_text gives us a str like:  "name: jquery"      
      # we split it at first ':', then strip out whitespace.
      #
      # Then call a transform on the value.  By default, this
      # just returns the value back.  But this can be overriden
      # based on the key name.  For example, we convert versions
      # in to an array
      def extract_lib_info(lib_html)
        transform = Hash.new(lambda {|val| val})
        transform.merge!({
          "versions" => lambda {|val| val.split(', ').reverse }
        })
        
        (lib_html / 'dd.al-libstate').inject({}) do |accum, prop|
          key, val = prop.inner_text.split(":", 2).map {|s| s.strip}
          accum[key] = transform[key].call(val)
          accum
        end
      end  
    end
  end
end