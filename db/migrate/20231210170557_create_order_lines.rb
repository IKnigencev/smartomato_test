class CreateOrderLines < ActiveRecord::Migration[7.1]
  def change
    create_table :order_lines do |t|
      t.references :order, index: true
      t.string :name, comment: "Название товара"
      t.decimal :cost, precision: 10, scale: 2, comment: "Цена товара"
      t.integer :count, comment: "Количество товара (штуки)"
      t.decimal :total, precision: 10, scale: 2, comment: "Общая стоимость указанного количества"

      t.timestamps
    end
  end
end
