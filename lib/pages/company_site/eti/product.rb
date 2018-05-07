module CompanySite
  module ETI
    class Table
      class Product < Products
        attr_reader :element, :products

        def initialize(element)

          return @element
        end



        def name
          @products.names_elements[index].element.text
        end

        def name=(value)
          self.browser
            .action
            .move_to(@products.names_elements[index].element)
            .click
            .send_keys(Selenium::WebDriver::Keys::KEYS[:enter])
            .send_keys(value)
            .send_keys(Selenium::WebDriver::Keys::KEYS[:enter])
            .perform

          wait_saving
        end

        def index
          @products.products_elements.index(@element)
        end

        def battery
          @products.battery_elements[index].tr('%', '').to_i
        end

        ActiveSupport.run_load_hooks(:'apress/selenium_eti/company_site/eti/product', self)
      end
    end
  end
end
