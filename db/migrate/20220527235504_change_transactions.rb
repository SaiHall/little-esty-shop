class ChangeTransactions < ActiveRecord::Migration[5.2]
  def change
    change_column :transactions, :credit_card_number, :string do


    end
  end
end
