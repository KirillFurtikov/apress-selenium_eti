module CompanySite
  module ETI
    class Table
      class Products < self
        include CompanySite::ETI

        button(:add_new_product, css: '.new.js-add-product')
        elements(:products, :row, css: "*[id^='product-item']")
        elements(:names, :cell, css: '.js-eti-name')
        elements(:public_state_icon, :cell, css: '.js-eti-status')
        elements(:battery, :cell, css: '.js-battery-wrapper')

        def product(value)
          if value.is_a? String
            name_element = names_elements.select { |n| n.text == value }.first
            products_elements[names_elements.index(name_element)]
          elsif value.is_a? Integer
            products_elements[value]
          else
            nil
          end
        end

        def product_index(product)
          products_elements.index(product)
        end

        def add_product(params = {})
          add_new_product
          wait_until { products_elements[0].attribute('class').include?('new') }
          set_name(product: products_elements[0], text: params[:name]) if params.key? :name
        end

        def set_name(params = {})
          name_element = names_elements[product_index(params[:product]) || 0]
          browser
            .action
            .move_to(name_element.element)
            .click
            .send_keys(Selenium::WebDriver::Keys::KEYS[:enter])
            .send_keys(params[:text])
            .send_keys(Selenium::WebDriver::Keys::KEYS[:enter])
            .perform

          wait_saving
        end

        def name(product)
          return if product.nil?
          names_elements[product_index(product)].element.text
        end

        def battery_value
          battery.tr('%', '').to_i
        end

        def price
          price_cell_element.text
        end

        def public_state(product)
          public_state_icon_elements[product_index(product)].attribute('data-public_state')
        end

        def create_and_set_product_fields(options = {})
          add_product
          options.each do |field_key, field_value|
            send("set_#{field_key}", field_value)
          end
        end

        def set_price_from_to(options = {})
          browser
            .action
            .move_to(price_cell_element.element)
            .click
            .perform

          select_from_to
          self.price_from = options.fetch(:from, '')
          self.price_to = options.fetch(:to, '')

          save_price
          wait_saving
        end

        def set_discount_price(options = {})
          browser
            .action
            .move_to(price_cell_element.element)
            .click
            .perform

          select_discount

          self.previous_price = options.fetch(:previous, '')
          self.discount_price = options.fetch(:discount, '')
          discount_expires_at_date_element.element.send_keys(Selenium::WebDriver::Keys::KEYS[:enter])

          save_price
          wait_saving
        end

        def set_price(text)
          browser
            .action
            .move_to(price_cell_element.element)
            .click
            .send_keys(price_text_area_element.element, text)
            .perform

          try_to(:save_price)
          wait_saving
        end

        def set_wholesale_price(options = {})
          browser
            .action
            .move_to(wholesale_price_cell_element.element)
            .click
            .perform

          self.wholesale_price = options.fetch(:wholesale_price, '')
          self.wholesale_number = options.fetch(:wholesale_number, '')

          save_wholesale_price
          wait_saving
        end

        def set_rubric(text)
          browser
            .action
            .move_to(rubric_cell_element.element)
            .click
            .perform

          self.rubric_search = text
          rubric_search_submit
          wait_until { first_rubric_search_result? }
          first_rubric_search_result

          wait_saving
        end

        def set_image(path)
          image_cell
          upload_file(upload_image_element, path)
          wait_until { image_loaded? }
          close_image_uploader
        end

        def set_short_description(text)
          browser
            .action
            .move_to(short_description_cell_element.element)
            .click
            .send_keys(Selenium::WebDriver::Keys::KEYS[:enter])
            .perform

          wait_until { inframe_block? }

          execute_script("$('.edit-announce iframe').get()[0].contentWindow.document.body.innerHTML='#{text}'")

          browser
            .action
            .move_to(short_description_cell_element.element)
            .send_keys(Selenium::WebDriver::Keys::KEYS[:enter])
            .perform

          wait_saving
        end

        def set_description(text)
          browser
            .action
            .move_to(description_cell_element.element)
            .click
            .send_keys(Selenium::WebDriver::Keys::KEYS[:enter])
            .perform

          wait_until { description? }
          description_element.send_keys(text)
          save_description

          wait_saving
        end

        def set_portal_traits(name, options = {})
          Page.text_area(:trait_1, xpath: "//input[@data-name='#{CONFIG['eti']['portal_traits']['trait_1']}']")
          Page.text_area(:trait_2, xpath: "//input[@data-name='#{CONFIG['eti']['portal_traits']['trait_2']}']")
          Page.link(:trait_link1, xpath: "//a[text()='#{options.fetch(:trait_1, '')}']")
          Page.link(:trait_link2, xpath: "//a[text()='#{options.fetch(:trait_2, '')}']")
          Page.span(:portal_traits_cell, xpath:
            "//td[@data-text='#{name}']/..//*[contains(text(), 'указать характеристики')]")

          wait_until { portal_traits_cell? }

          browser
            .action
            .move_to(portal_traits_cell_element.element)
            .click
            .perform

          self.trait_1 = options.fetch(:trait_1, '')
          wait_until { trait_link1? }
          trait_link1

          self.trait_2 = options.fetch(:trait_2, '')
          wait_until { trait_link2? }
          trait_link2

          save_portal_traits
          wait_saving
        end

        def set_exists(value)
          Page.link(:exists_link, xpath: "//li/a[text()='#{value}']")

          browser
            .action
            .move_to(exist_cell_element.element)
            .click
            .perform

          exists_link
          wait_saving
        end

        ActiveSupport.run_load_hooks(:'apress/selenium_eti/company_site/eti/table_products', self)
      end
    end
  end
end
