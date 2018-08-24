module CompanySite
  module ETI
    class Table
      class DescriptionPopup < Popup
        div(:popup, css: '.js-edit-description')

        text_area(:text, css: '.js-edit-description .cke_textarea_inline')
        button(:save, css: '.js-edit-description [title="Сохранить (Ctrl + Enter)"]')
        button(:cancel, css: '.js-edit-description [title="Отменить (Esc)"]')
      end
    end
  end
end
