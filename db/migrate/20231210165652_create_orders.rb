class CreateOrders < ActiveRecord::Migration[7.1]
  def change
    create_table :orders do |t|
      t.string :user_name, comment: "Имя клиента, совершившиий заказ"
      t.string :phone, comment: "Номер клиента, совершившиий заказ"
      t.string :email, comment: "Почта клиента, совершившего заказ"
      t.string :address, comment: "Адрес доставки"
      t.decimal :total, precision: 10, scale: 2, comment: "Сумма заказа"
      t.integer :status, default: 0, comment: "Статус оплаты: новый, начата оплата, ошибка оплаты, оплачен"
      t.jsonb :metadata, comment: "Метаданные платежной системы"

      t.timestamps
    end
  end
end
