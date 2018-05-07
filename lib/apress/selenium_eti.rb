gem_directory = Gem::Specification.find_by_name("apress-selenium_eti").gem_dir
#Dir["#{gem_directory}/lib/pages/**/*.rb"].each { |file| require file }

require_relative '../pages/company_site/eti/eti'
require_relative '../pages/company_site/mini_eti_page'
require_relative '../pages/company_site/eti/table'
require_relative '../pages/company_site/eti/action_panel'
require_relative '../pages/company_site/eti/catalog'
require_relative '../pages/company_site/eti/header'
require_relative '../pages/company_site/eti/scenario'
require_relative '../pages/company_site/eti/table_header'
require_relative '../pages/company_site/eti/table_products'
require_relative '../pages/company_site/eti/table_status_bar'
require_relative '../pages/company_site/eti/product'
