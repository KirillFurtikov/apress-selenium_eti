module CompanySite
  module ETI
    class Table
      class Popup < self
        attr_accessor :wait_popup_timeout

        DEFAULT_WAIT_POPUP_TIMEOUT = 2

        def initialize
          super
          @wait_popup_timeout = DEFAULT_WAIT_POPUP_TIMEOUT
        end

        div(:popup, css: '[class*="modern"][style*="block"]')

        def wait_popup(timeout = @wait_popup_timeout)
          wait_until(timeout) do
            yield if block_given?
            popup?(0.2)
          end
        end
      end
    end
  end
end
