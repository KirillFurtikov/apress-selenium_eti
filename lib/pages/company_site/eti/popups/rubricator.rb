module CompanySite
  module ETI
    class Table
      class Rubricator < self
        button(:close, css: '.ui-dialog-titlebar-close')

        text_area(:search, css: '.js-input-rubric-search')
        button(:search_submit, css: '.js-button-rubric-search')

        elements(:found_rubrics_names, css: '.js-rubric-found .js-src-link')
        elements(:found_rubrics_parents, css: '.js-rubric-found .search-parents-rubrics')

        def find(value)
          self.search = value
          search_submit
        end

        def select_result(name)
          found_rubrics_names_elements.find { |rubric_name| rubric_name.text == name }.click
        end

        # Выбор рубрики из дерева рубрик с раскрытием структуры
        # На вход массив из названий (от верхнего к нижнему уровню)
        def select_rubric(*rubric)
          rubric_tree = rubric

          uncover_tree(rubric_tree)
          rubric_in_tree(rubric_tree.last)
        end

        # Разворачивание дерева рубрик по переданному массиву
        def uncover_tree(tree)
          tree.each { |rubric_name| uncover_rubric(rubric_name) }
        end

        # Разворачивание конкретной рубрики в дереве рубрик
        def uncover_rubric(name)
          Page.button(:rubric_cover, xpath: "//span[contains(text(),"\
            "'#{name}')]/../*[contains(@class, 'js-rubricator-toggler') and not(contains(@class, 'open'))]")
          rubric_cover if rubric_cover?(2)
        end

        # Выбор конкретной рубрики в дереве рубрик
        def rubric_in_tree(name)
          Page.button(:rubric_name, xpath: "//span[contains(text(),'#{name}')]")
          rubric_name
        end
      end
    end
  end
end
