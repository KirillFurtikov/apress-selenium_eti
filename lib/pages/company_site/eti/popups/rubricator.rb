module CompanySite
  module ETI
    class Table
      class Rubricator < self
        button(:close, css: '.ui-dialog-titlebar-close')

        text_area(:search, css: '.js-input-rubric-search')
        button(:search_submit, css: '.js-button-rubric-search')

        link(:found_rubrics_names, css: '.search-rubrics-container .js-src-link')
        span(:found_rubrics_parents, css: '.search-rubrics-container .search-parents-rubrics')

        def find(value)
          self.search = value
          search_submit
        end

        def select_result(name)

        end
      end
    end
  end
end
