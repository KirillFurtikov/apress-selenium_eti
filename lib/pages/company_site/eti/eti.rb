module CompanySite
  module ETI

    def wait_saving
      status_bar = ::Table::StatusBar.new
      sleep 1
      wait_until? { status_bar.status == 'Сохранение изменений...' }
      wait_until? { status_bar.status == 'Все изменения сохранены' }
    end
  end
end
