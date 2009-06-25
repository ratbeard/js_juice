require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require "query"

module JsJuice

  describe "Querying Google" do  
    before :all do
      @google = Query::Google.new
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
      @google.names.sort.should == @expected_libs.sort
    end  
                                      
    it "allows accessing libraries by name with []'s" do
      mootools = @google.libs.find {|lib| lib.name == 'mootools'}
      @google['mootools'].should == mootools
    end                                        
    
    it "returns expected versions for jquery" do
      versions = @google['jquery'].versions
      versions.should have_at_least(5).versions
    end    
  end  
  
  describe "library result object" do
    before :each do
      @google = Query::Google.new
      @jquery = @google['jquery']
    end                          
    
    it "tells if a library offers an uncompressed version" do
      @google['jquery'].should have_uncompressed
      @google['prototype'].should_not have_uncompressed
      
      
    end
    describe "url" do
      it "is by default the latest compressed library version" do
        # given
        version = @jquery.latest
        expected_url = "http://ajax.googleapis.com/ajax/libs/jquery/#{version}/jquery.min.js"
        # then
        @jquery.url.should == expected_url
      end                                 
      
      it "can be overriden what version to use" do
        # given
        expected_url = "http://ajax.googleapis.com/ajax/libs/jquery/1.3.0/jquery.min.js"
        # then
        @jquery.url(:version => '1.3.0').should == expected_url
      end
    end
  end
  


end