# frozen_string_literal: true

require_relative "transaction_subscriber/version"

module ActiveRecord
  class TransactionSubscriber < ActiveRecord::LogSubscriber
    thread_mattr_accessor :transactions

    def sql(event)
      payload = event.payload
      return if payload[:cached]

      sql = payload[:sql]

      case payload[:name]
      when 'TRANSACTION'
        case sql
        when 'BEGIN', 'SAVEPOINT'
          my_transactions << { start_at: event.time }
        when 'COMMIT', 'ROLLBACK'
          tx = my_transactions.pop
          if tx
            logging(payload[:name], tx, event.end)
          end
        else
          # Unknown transaction
        end
      when *IGNORE_PAYLOAD_NAMES
        # no-op
      else
        tx = my_transactions.last
        if tx
          type = sql_type(sql)
          if type
            tx[type] ||= []
            tx[type] << event.duration
          end
        end
      end
    end

    def my_transactions
      self.class.transactions ||= []
    end

    def logging(name, tx, end_at)
      elapsed_time = ((end_at - tx[:start_at]) * 1000.0).round(1)
      text = "  Transaction #{name} real time: #{elapsed_time}ms"
      %i[lock select insert update delete].each do |type|
        next unless tx[type]
        count = tx[type].size
        total = tx[type].sum.round(1)
        text << ", #{type}: #{count} (#{total}ms)"
      end
      info color(text, :magenta, true)
    end

    def sql_type(sql)
      case sql
      when /select .*for update/mi, /\A\s*lock/mi
        :lock
      when /\A\s*select/i
        :select
      when /\A\s*insert/i
        :insert
      when /\A\s*update/i
        :update
      when /\A\s*delete/i
        :delete
      else
        nil
      end
    end
  end
end
