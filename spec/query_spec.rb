require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require "query"

module JsJuice


  describe "Querying Google" do  
    before :all do
      # @google ||= Query::Google.new
      @response = Query::Google.new
      @expected_libs = %w{
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
    end
    
    it "returns expected libraries" do    
      @expected_libs.each do |name| 
        @response.names.should include(name)        
      end

      ['atlas', 'ui'].each do |name| 
        @response.names.should_not include(name)        
      end  
    end  
                                      
    it "allows accessing libraries by name with []'s" do
      mootools = @response.libs.find {|lib| lib.name == 'mootools'}
      @response['mootools'].should == mootools
    end                                        
    
    it "returns expected versions for jquery" do
      # given
      versions = @response['jquery'].versions
      # then
      versions.should have(5).versions
    end
    
  end


end