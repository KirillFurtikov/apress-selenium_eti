module CompanySite
  module ETI
    class Header < Page
      checkbox(:exact_search, css: '#exact_search')
      text_area(:product_search, xpath: "//*[@id='product-bindings-search']")
      button(:search_button, css: '.js-search-submit')

      def search_product(name)
        check_exact_search
        self.product_search = name
        search_button
        wait_until { product_names_elements[0] != name }
      end

      ActiveSupport.run_load_hooks(:'apress/selenium_eti/company_site/eti/header', self)
    end
  end
end
