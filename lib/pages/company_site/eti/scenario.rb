module CompanySite
  module ETI
    class Scenario < Page
      include CompanySite::ETI

      ActiveSupport.run_load_hooks(:'apress/selenium_eti/company_site/eti/scenario', self)
    end
  end
end
