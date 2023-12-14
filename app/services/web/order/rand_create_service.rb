# frozen_string_literal: true

module Web
  ##
  # Создание случайного заказа
  #
  class Order::RandCreateService
    def self.call
      new.call
    end

    def call
      order = ::Order.new(rand_attr_for_order)
      (0..rand(1..5)).map { order.order_line << init_order_line }
      order.total = order.order_line.sum(&:total)
      order.save!
    end

    private
      def rand_attr_for_order
        {
          user_name: rand_string,
          phone: "7#{rand(10**9..10**10)}",
          email: "#{rand_string}@#{rand_email_domain}",
          address: rand_string
        }
      end

      def init_order_line
        ::OrderLine.new(rand_attr_for_order_lines)
      end

      def rand_attr_for_order_lines
        cost = rand(1...10_000)
        count = rand(1..10)
        {
          name: rand_string,
          cost: cost,
          count: count,
          total: cost * count
        }
      end

      def rand_string
        (0...(rand(5..10))).map { ("a".."z").to_a[rand(26)] }.join
      end

      def rand_email_domain
        %w[
          mail.ru callibri.ru yahoo.com inbox.ru
          gmail.com bk.ru yandex.ru list.ru
          me.com ya.ru i.ua live.ru
        ].sample
      end
  end
end
