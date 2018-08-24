module CompanySite
  module ETI
    class Table
      class Popup < self
        attr_accessor :default_wait_popup_timeout

        def initialize
          super
          @default_wait_popup_timeout = 2
        end

        div(:popup, css: '[class*="modern"][style*="block"]')

        def wait_popup(timeout = default_wait_popup_timeout)
          wait_until(timeout) do
            yield if block_given?
            popup?(0.2)
          end
        end
      end
    end
  end
end
