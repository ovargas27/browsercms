require File.dirname(__FILE__) + '/../spec_helper'

describe ContentType do
  before do
    @c = ContentType.new({:name => "HtmlBlock"})
  end

  it "should correctly convert name to classes" do
    @c.name.should == "HtmlBlock"
    @c.name.classify.should == "HtmlBlock"
    @c.name.classify.constantize.should == HtmlBlock
  end

  it "should have model_class method" do
    @c.model_class.should == HtmlBlock
  end

  it "should have display_name that shows renderable name from class" do
    @c.display_name.should == "Html"
  end

  it "should have plural display_name" do
    @c.display_name_plural.should == "Html"
  end

  it "should have content_block_type to help build urls" do
    @c.content_block_type.should == "html_blocks"
  end

  it "should create a new instance of its class via new_content with no params" do
    @b = @c.new_content
    @b.class.should == HtmlBlock
  end

  it "should create a new instance with params" do
    @b = @c.new_content(:name => "Test")
    @b.name.should == "Test"
  end

  describe "find_by_key" do
    before(:each) do
      create_content_type(:name=>"HtmlBlock")
    end
    it "should find based on key" do
      @content_type = ContentType.find_by_key("html_block")
      @content_type.model_class.should == HtmlBlock
    end

    it "should raise exception if no block was registered of that type" do
      @find = lambda{ ContentType.find_by_key("non_existant_type") }
      @find.should raise_error
    end
  end

  describe "templates to render CRUD actions" do
    describe "with core blocks (no overrides)" do
      it "should return the standard view for :new" do
        @c.template_for_new.should == "cms/blocks/new"
      end

      it "should return basic edit for :edit" do
        @c.template_for_edit.should == "cms/blocks/edit"
      end

    end
    describe "with blocks (like portlets) that override template methods" do
      before(:each) do
        @content_type = ContentType.new({:name => "Portlet"})
      end
      it "should return custom new" do
        @content_type.template_for_new.should == "cms/portlets/select_portlet_type"
      end
      it "should return custom edit" do
        @content_type.template_for_edit.should == "cms/portlets/edit"
      end
    end


  end
end