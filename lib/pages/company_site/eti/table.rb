module CompanySite
  module ETI
    class Table < Page
      include CompanySite::ETI

      div(:load_process, css: '.js-load-process')

      checkbox(:product_checkbox, css: '.js-check-product')
      button(:save_description, css: '.edit-description .js-check')
      button(:save_wholesale_price, css: '.js-save-wholesale')
      button(:save_portal_traits, css: '.js-popup-traits-values .fa-check ')
      span(:progress_bar, css: '#pb')
      button(:to_catalog, css: '.ml15')
      span(:save_status, css: '.js-status-bar-content')
      button(:add_products_menu, css: '.sb-label')
      button(:add_product_manually, css: '.js-add-product')
      span(:empty_product_name, xpath: "//*[text()[contains(., 'Указать название')]]")

      span(:name_cell, xpath: "//*[@data-placeholder='Указать название']")
      span(:price_cell, xpath: "//*[contains(text(), 'Указать розничную цену')]")
      span(:wholesale_price_cell, css: '.js-eti-wholesaleprice .bp-price-free')
      span(:exist_cell, xpath: "//*[contains(text(), 'Указать наличие')]")
      text_area(:edit_text_area, css: '.edit-text')

      text_area(:price_text_area, css: '.js-text-price')
      text_area(:price_from, xpath: "(//*[@class = 'pv-text-field js-text-price'])[2]")
      text_area(:price_to, css: '.js-text-price-max')
      text_area(:previous_price, css: '.js-text-price-prev')
      text_area(:discount_price, css: '.js-product-form-discount-price')
      text_area(:discount_expires_at_date, css: '.js-discount-expires-at')
      text_area(:short_description_cell, css: '.js-eti-announce')
      text_area(:description_cell, css: '.js-eti-description')
      text_area(:description, css: '.cke_textarea_inline')
      text_area(:wholesale_price, css: '.js-wholesale-price')
      text_area(:wholesale_number, css: '.js-wholesale-min-qty')
      button(:save_price, css: '.ui-button.ui-widget.ui-state-default.ui-corner-all.ui-button-text-only')

      span(:price_value, css: '.bp-price.fsn')
      spans(:price_values, css: '.bp-price.fsn')
      span(:discount_price_value, css: '.discount .bp-price.fsn')
      span(:previous_price_value, css: '.bp-price.fwn.fsn')
      span(:discount_expires_at_date_value, css: '.discount-date')

      span(:exists_value, css: '.cost-dog-link')
      span(:upload_image, name: 'images')
      image(:image, css: '.ibb-img.js-img')
      # HACK: цепляемся за .ui-resizable, потому что больше нет уникальных идентификаторов
      button(:close_image_uploader, css: '.ui-resizable .ui-dialog-titlebar-close')

      span(:image_uploader, css: '.ui-dialog.ui-widget.ui-widget-content.ui-corner-all.ui-front.ui-draggable')
      button(:image_cell, css: '.js-upload-photo .blank-image')
      button(:image_upload_btn, css: '.js-upload-input')
      span(:thermometer, css: '.js-battery-wrapper')
      span(:rubric_cell, css: '.js-rubric-preview-link')
      text_area(:rubric_search, css: '.js-input-rubric-search')
      button(:rubric_search_submit, css: '.js-button-rubric-search')
      button(:first_rubric_search_result, css: '.js-src-link')
      link(:page_2, xpath: "//*[@data-page='2']")
      link(:page_1, xpath: "//*[@data-page='1']")
      span(:found_products_count, css: '.js-products-count')
      spans(:product_names, css: '.js-eti-name')
      radio_button(:from_to, xpath: "(//*[@class = 'va-1 mr5 js-select-type-price'])[2]")
      radio_button(:discount, xpath: "(//*[@class = 'va-1 mr5 js-select-type-price'])[3]")

      button(:operation_undo, css: 'div.operation.undo')
      button(:operation_redo, css: 'div.operation.redo')
      button(:publish_product, css: '.dialog-status .published')
      button(:archive_product, css: '.dialog-status .archived')

      button(:amount_selector, css: '.ptrfap-choose-amount-wrapper>.custom-combobox>.ui-button')
      divs(:product, css: 'tr.pt-tr')
      div(:save_status, css: '.js-status-bar-content')
      span(:first_product_status, css: '.js-eti-status > div > i')
      button(:save_deals, xpath: "//*[@class='ui-button-text'][contains(text(), 'Сохранить')]")
      checkbox(:deal_product_checkbox, xpath: "//*[text()[contains(., \'#{CONFIG['offer_with_product']}\')]]/input")

      divs(:product_rows, css: '.js-pt-tr')
      span(:inframe_block, css: '.js-bcm-content')
      span(:group_cell, css: '.js-group-preview-link')
      button(:submit, xpath: "//*[@value='Выбрать']")
      button(:close_support_contacts, css: '.js-support-contacts-close')

      alias old_confirm confirm
      def save
        old_confirm
        confirm_not_exists?(30)
      end

      def product_name?(name)
        Page.span(:product_name_span, xpath: "//*[contains(text(), '#{name}')]")
        product_name_span?
      end

      def product_rubric_tree(name)
        Page.span(:rubric_header_span, xpath:
          "//td[@data-text='#{name}']/..//span[@class='dashed-span js-rubric-preview-link']")
        rubric_header_span_element.text
      end

      def delete_product(name)
        search_product(name)
        Page.button(:delete_product_icon, xpath:
          "//td[@data-text='#{name}']/..//i[contains(@class, 'js-delete-product')]")
        Page.span(:product_line, xpath: "//td[@data-text='#{name}']/ancestor::tr[contains(@class,'pt-tr')]")

        product_line_element.hover
        confirm(true) { delete_product_icon }
        wait_saving
      end

      def copy_product(name)
        Page.button(:copy_product_icon, xpath: "//td[@data-text='#{name}']/..//i[contains(@class, 'js-copy-product')]")
        copy_product_icon

        wait_saving
      end

      def change_status_to_published(name)
        Page.button(:product_status, xpath: "//*[@data-text='#{name}']/..//*[contains(@class, 'js-change-status')]")
        product_status
        publish_product

        wait_saving
      end

      def change_status_to_archived(name)
        Page.button(:product_status, xpath: "//*[@data-text='#{name}']/..//*[contains(@class, 'js-change-status')]")
        product_status
        archive_product

        wait_saving
      end

      def set_group(name)
        Page.button(:product_group, xpath: "//*[@id='popup-content']//*[contains(text(), '#{name}')]")
        group_cell_element.click
        product_group
        submit
      end

      def choose_amount_of_products_on_page(count)
        amount_selector
        Page.button(:product_amount,
                    xpath: "//*[contains(@class, 'js-choose-amount-combobox')]//*[contains(text(), '#{count}')]")
        product_amount
      end

      ActiveSupport.run_load_hooks(:'apress/selenium_eti/company_site/eti/table', self)
    end
  end
end
