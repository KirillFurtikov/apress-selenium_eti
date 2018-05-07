module CompanySite
  module ETI
    class Catalog < Page
      include CompanySite::ETI

      ActiveSupport.run_load_hooks(:'apress/selenium_eti/company_site/eti/catalog', self)
    end
  end
end
