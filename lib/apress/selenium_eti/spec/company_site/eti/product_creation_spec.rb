require 'spec_helper'

describe 'ЕТИ' do
  before(:all) do
    @cs_eti_table            = CompanySite::ETI::Table.new
    @cs_eti_table_products   = CompanySite::ETI::Table::Products.new
    @cs_eti_table_status_bar = CompanySite::ETI::Table::StatusBar.new
    @cs_eti_header           = CompanySite::ETI::Header.new
    @cs_main_page            = CompanySite::MainPage.new
    @cs_contacts_sidebar     = Extensions::CompanySite::SupportContactsSidebar.new

    log_in_as(:user)
    navigate_to_eti
    @cs_contacts_sidebar.close
    # @cs_main_page.close_banner
    # @cs_eti_table.close_support_contacts if @cs_eti_table.close_support_contacts?
  end

  describe 'Создание товара' do
    context 'когда товар без рубрики' do
      before(:all) do
        @name = Faker::Number.number(5)
        @cs_eti_table_products.add_product(name: @name)
        @cs_eti_header.search_product(@name)
        @product = @cs_eti_table_products.product(name: @name)
      end

      after(:all) { @cs_eti_table_products.delete_product(@product) }

      it('введенное имя отображается') { expect(@cs_eti_table_products.name(@product)).to eq @name }
      it('товар не опубликован') { expect(@cs_eti_table_products.public_state(@product)).to eq :unpublished }
    end

    fcontext 'когда товар с рубрикой' do
      before(:all) do
        @name = Faker::Number.number(5)
        @cs_eti_table_products.add_product(name: @name)
        @product = @cs_eti_table_products.product(name: @name)
        @cs_eti_table_products.set_rubric(@product, CONFIG['eti']['rubric'])
        @cs_eti_header.search_product(@name)
        @product = @cs_eti_table_products.product(name: @name)
        binding.pry
      end

      after(:all) { @cs_eti_table_products.delete_product(@product) }

      it('введенное имя отображается') { expect(@cs_eti_table_products.name(@product)).to eq @name }
      it('рубрика привязана') { expect(@cs_eti_table_products.rubric(@product)).to include CONFIG['eti']['rubric'] }
      it('товар опубликован') { expect(@cs_eti_table_products.public_state(@product)).to eq :published }
    end

    context 'когда копируем товар' do
      before(:all) do
        @product = {
          name: Faker::Name.title,
          rubric: CONFIG['eti']['rubric'],
          exists: CONFIG['eti']['exists']['in stock'],
          short_description: CONFIG['product_creation']['short_description']['valid'],
          description: 'description',
          price_from_to: {from: Faker::Number.number(3), to: Faker::Number.number(4)},
          wholesale_price: {wholesale_price: Faker::Number.number(2), wholesale_number: Faker::Number.number(2)}
        }

        @portal_traits = {
          trait_1: CONFIG['eti']['portal_traits']['trait_value_1'],
          trait_2: CONFIG['eti']['portal_traits']['trait_value_2']
        }

        @cs_eti_table.create_and_set_product_fields(@product)
        @cs_eti_table.refresh
        @cs_eti_table.search_product(@product[:name])
        @cs_eti_table.set_portal_traits(@product[:name], @portal_traits)
        @cs_eti_table.copy_product(@product[:name])

        @cs_eti_table.refresh
        @cs_eti_table.search_product(@product[:name])
      end

      it 'отобразится 2 идентичных товара' do
        @first_product = @cs_eti_table.product_rows_elements[0].text

        expect(@cs_eti_table.product_rows_elements.length).to eq 2
        expect(@cs_eti_table.product_rows_elements[1].text).to eq @first_product
      end

      after(:all) { 2.times { @cs_eti_table.delete_product(@product[:name]) } }
    end
  end
end
