require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require "query"

module JsJuice


  describe "Querying Google" do  
    
    before :all do
      # @google ||= Query::Google.new
      @response = Query::Google.new
    end
    
    it "returns expected libraries" do 
      expected_libs = %w{
        swfobject
        jquery
        jqueryui
        prototype
        scriptaculous
        mootools
        dojo
        yui
        ext-core
      }
      unexpected_libs = %w{
        atlas
        core-dojo-tools-ui
      }
         
      # then
      expected_libs.each do |name| 
        @response.names.should include(name)        
      end
      
      unexpected_libs.each do |name| 
        @response.names.should_not include(name)        
      end  
      
    end
  end


end