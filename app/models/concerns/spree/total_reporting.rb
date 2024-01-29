module Spree
    module TotalReporting
        extend ActiveSupport::Concern
        extend DisplayMoney
        money_methods :total_lifetime_value, :total_average_order_value
    
        def report_values_for(report_name, store)
            store ||= Store.default
    
            completed_orders(store).pluck(:currency).uniq.each_with_object([]) do |currency, arr|
            arr << send("display_#{report_name}", store: store, currency: currency)
            end
        end
    
        def total_lifetime_value(**args)
            total_lifetime_value = 0
            Spree::Store.all.each do |store|

                total_lifetime_value += order_calculate(operation: :sum,
                                column: :total,
                                store: store,
                                **args)
            end
            total_lifetime_value
        end
    
        def total_average_order_value(**args)
            if total_order_count(**args) > 0
                total_lifetime_value(**args) / total_order_count(**args)
            else
                BigDecimal('0.00')
            end
        end
    
        def total_order_count(store = nil)
            total_order_count = 0
            Spree::Store.all.each do |store|

                total_order_count += order_calculate(store: store,
                                currency: store.supported_currencies.split(','),
                                operation: :count,
                                column: :all)
            end
            total_order_count
        end
    
        private
    
        def order_calculate(operation:, column:, store: nil, currency: nil)
            store ||= Store.default
            currency ||= store.default_currency
    
            completed_orders(store).where(currency: currency).calculate(operation, column) || BigDecimal('0.00')
        end
    
        def completed_orders(store)
            orders.for_store(store).complete.order(currency: :desc)
        end
    end
  end