# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2023_12_10_170557) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "order_lines", force: :cascade do |t|
    t.bigint "order_id"
    t.string "name", comment: "Название товара"
    t.decimal "cost", precision: 10, scale: 2, comment: "Цена товара"
    t.integer "count", comment: "Количество товара (штуки)"
    t.decimal "total", precision: 10, scale: 2, comment: "Общая стоимость указанного количества"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["order_id"], name: "index_order_lines_on_order_id"
  end

  create_table "orders", force: :cascade do |t|
    t.string "user_name", comment: "Имя клиента, совершившиий заказ"
    t.string "phone", comment: "Номер клиента, совершившиий заказ"
    t.string "email", comment: "Почта клиента, совершившего заказ"
    t.string "address", comment: "Адрес доставки"
    t.decimal "total", precision: 10, scale: 2
    t.integer "status", default: 0, comment: "Статус оплаты: новый, начата оплата, ошибка оплаты, оплачен"
    t.jsonb "metadata", comment: "Метаданные платежной системы"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
