# frozen_string_literal: true

require 'active_record'
require 'active_record/log_subscriber'

module ActiveRecord
  class TransactionSubscriber < LogSubscriber
    VERSION = '0.1.3'
  end
end
