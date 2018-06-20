require 'spec_helper'

describe 'ЕТИ' do
  before(:all) do
    @cs_eti_table = CompanySite::EtiPage.new
    @cs_main_page = CompanySite::MainPage.new

    log_in_as(:user)
    navigate_to_eti
    @cs_main_page.close_banner
  end

  describe 'Добавление групп' do
    context 'когда привязываем группу к товару' do
      before(:all) do
        @product = {name: Faker::Number.number(5)}
        @cs_eti_table.create_and_set_product_fields(@product)
        @cs_eti_table.set_group(CONFIG['product_creation']['group'])
        @cs_eti_table.wait_saving
        @cs_eti_table.refresh
        @cs_eti_table.search_product(@product[:name])
      end

      it 'группа привязывается' do
        expect(@cs_eti_table.group_cell).to eq CONFIG['product_creation']['group']
      end

      context 'когда выбираем другую группу' do
        before do
          @cs_eti_table.set_group(CONFIG['product_creation']['group_2'])
          @cs_eti_table.wait_saving
          @cs_eti_table.refresh
        end

        it 'группа меняется на новую' do
          expect(@cs_eti_table.group_cell).to eq CONFIG['product_creation']['group_2']
        end
      end

      after(:all) { @cs_eti_table.delete_product(@product[:name]) }
    end
  end
end
