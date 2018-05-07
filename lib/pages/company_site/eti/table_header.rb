module CompanySite
  module ETI
    class Table
      class Header < self

        ActiveSupport.run_load_hooks(:'apress/selenium_eti/company_site/eti/table_header', self)
      end
    end
  end
end
