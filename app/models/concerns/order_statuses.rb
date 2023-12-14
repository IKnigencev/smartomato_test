# frozen_string_literal: true

##
# Статусы заказа
#
module OrderStatuses
  extend ActiveSupport::Concern

  included do
    ##
    # Данные для представления статусов
    #
    # @return [Hash<Symbol>]
    #
    def self.hash_statuses
      { init: 0, start: 1, error: 2, finish: 3 }
    end

    ##
    # Список доступных статусов
    #
    # @return [Array<String>]
    #
    def self.avaliable_statuses
      hash_statuses.keys.map(&:to_s)
    end
  end
end
