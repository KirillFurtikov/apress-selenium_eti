require 'spec_helper'

describe 'Мини-ЕТИ' do
  before(:all) do
    @cs_eti_table     = CompanySite::EtiPage.new
    @cs_main_page     = CompanySite::MainPage.new
    @cs_mini_eti_page = CompanySite::MiniEtiPage.new

    log_in_as(:user)
    navigate_to_minieti
    @cs_main_page.close_banner
    @cs_eti_table.close_support_contacts if @cs_eti_table.close_support_contacts?
  end

  describe 'Поля' do
    context 'когда заполняем имя' do
      before(:all) do
        @cs_eti_table.add_product
        @name = Faker::Number.number(5)
        @cs_eti_table.set_name(@name)
      end

      it 'введенное имя отображается' do
        expect(@cs_eti_table.product_name?(@name)).to be true
      end

      context 'когда добавляем картинку', skip: !RUN_CONFIG.fetch('local_running', false).to_b do
        before(:all) do
          @therm_value = @cs_eti_table.thermometer_value
          @cs_eti_table.set_image(IMAGE_PATH)
        end

        it 'картинка появляется' do
          expect(@cs_eti_table.image_loaded?).to be true
        end

        # Подсказка о том что изменения сохранены не появляется
        it 'увеличивается градус на термометре' do
          expect(
            wait_until? { @cs_eti_table.thermometer_value == (@therm_value + CONFIG['battery_percents']['image']) }
          ).to be true
        end
      end
    end

    context 'когда заполняем цену' do
      before(:all) do
        @cs_eti_table.add_product
        @cs_eti_table.set_name(Faker::Number.number(5))
        @thermometer_value = @cs_eti_table.thermometer_value
        @price = Faker::Number.number(3)

        @cs_eti_table.set_price(@price)
      end

      it 'введенная цена отображается' do
        expect(@cs_eti_table.price_value).to include @price
      end

      it 'увеличивается градус на термометре' do
        expect(@cs_eti_table.thermometer_value.to_i).to be @thermometer_value + CONFIG['battery_percents']['price']
      end
    end

    context 'когда заполняем цену от и до' do
      before(:all) do
        @cs_eti_table.add_product
        @cs_eti_table.set_name(Faker::Number.number(5))

        @thermometer_value = @cs_eti_table.thermometer_value
        @price_from_to = {from: Faker::Number.number(2), to: Faker::Number.number(3)}

        @cs_eti_table.set_price_from_to(@price_from_to)
      end

      it 'введенная цена отображается' do
        expect(@cs_eti_table.price_value).to include @price_from_to[:from], @price_from_to[:to]
      end
    end

    context 'когда заполняем цену со скидкой' do
      before(:all) do
        @cs_eti_table.add_product
        @cs_eti_table.set_name(Faker::Number.number(5))

        @thermometer_value = @cs_eti_table.thermometer_value
        @discount_price = {previous: Faker::Number.number(3), discount: Faker::Number.number(2)}

        @cs_eti_table.set_discount_price(@discount_price)
      end

      it 'введенные цены и дата окончания скидки отображаются' do
        expect(@cs_eti_table.discount_price_value).to include @discount_price[:discount]
        expect(@cs_eti_table.previous_price_value).to include @discount_price[:previous]
        expect(@cs_eti_table.discount_expires_at_date_value).to include Time.now.strftime("%d.%m.%Y")
      end
    end

    context 'когда заполняем наличие' do
      before do
        @cs_eti_table.add_product
        @cs_eti_table.set_name(Faker::Number.number(5))
        @cs_eti_table.set_exists(CONFIG['eti']['exists']['in stock'])
      end

      it 'для товара отобразится статус "В наличии"' do
        expect(@cs_eti_table.exists_value).to match(/[Вв] наличии/)
      end
    end

    context 'когда заполняем рубрику' do
      before(:all) do
        @cs_eti_table.add_product
        @cs_eti_table.set_name(Faker::Number.number(5))
        @rubric = @cs_eti_table.rubric_cell
        @cs_eti_table.set_rubric(CONFIG['eti']['rubric'])
      end

      it 'привязывается рубрика' do
        expect(@cs_eti_table.rubric_cell).to include CONFIG['eti']['rubric']
      end

      context 'когда отменяем действие' do
        before(:all) { @cs_eti_table.operation_undo }

        it 'рубрика исчезает' do
          expect(@cs_eti_table.rubric_cell).to eq @rubric
        end

        context 'когда повторяем отмененное действие' do
          before(:all) { @cs_eti_table.operation_redo }

          it 'привязывается рубрика' do
            expect(@cs_eti_table.rubric_cell).to include CONFIG['eti']['rubric']
          end
        end
      end

      after(:all) { @cs_eti_page.wait_saving }
    end
  end

  describe 'Пагинатор' do
    context 'когда переходим на вторую страницу' do
      before(:all) { @cs_eti_table.page_2 }

      it 'открывается вторая страница' do
        expect(no_page_errors?).to be true
        expect(@cs_eti_table.page_2_not_exists?).to be true
        expect(@cs_eti_table.page_1?).to be true
      end

      context 'когда возвращаемся на первую страницу' do
        before(:all) { @cs_eti_table.page_1 }

        it 'открывается первая страница' do
          expect(no_page_errors?).to be true
          expect(@cs_eti_table.page_1_not_exists?).to be true
          expect(@cs_eti_table.page_2?).to be true
        end
      end
    end
  end

  describe 'Удаление товара' do
    before do
      @cs_eti_table.add_product
      @name = Faker::Number.number(5)
      @cs_eti_table.set_name(@name)
      @cs_mini_eti_page.delete_first_product
    end

    it 'товар удаляется' do
      expect(@cs_eti_table.product_name?(@name)).to be false
    end
  end

  describe 'Копирование товара' do
    before do
      @cs_eti_table.add_product
      @name = Faker::Pokemon.name
      @cs_eti_table.set_name(@name)
      @cs_eti_table.set_price(@price = Faker::Number.number(5))
      @cs_eti_table.wait_saving

      @cs_mini_eti_page.copy_product
      @cs_eti_table.wait_saving
    end

    it 'товар копируется' do
      expect(@cs_eti_table.price_values_elements[0].text).to eq @cs_eti_table.price_values_elements[1].text
    end
  end

  context 'когда выбираем количество товаров на странице' do
    before { @cs_eti_table.choose_amount_of_products_on_page(50) }

    it 'количество товаров на странице равно выбранному значению' do
      expect(
        wait_until? { (@cs_eti_table.product_elements.size <= 50) && (@cs_eti_table.product_elements.size > 20) }
      ).to be true
    end
  end
end
