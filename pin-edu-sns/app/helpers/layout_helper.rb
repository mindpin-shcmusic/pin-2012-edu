module LayoutHelper
  def page_buttons
    content_tag :div, :class => :buttons do
      yield LayoutWidget
    end
  end

  module LayoutWidget
    extend ActionView::Helpers::UrlHelper
    extend ActionView::Helpers::TagHelper

    def self.button(text, path, options={})
      options.assert_valid_keys :class
      link_to text, path, :class => [:button, options[:class]]
    end
  end

end
