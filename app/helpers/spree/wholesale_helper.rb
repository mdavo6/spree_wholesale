module Spree
  module WholesaleHelper
    def display_wholesale_price(product_or_variant)
      product_or_variant.
        price_in(current_currency, true).
        display_price_including_vat_for(current_price_options).
        to_html
    end

    def registration_progress(current_state, numbers: false)
      states = ['login', 'store', 'address']
      items = states.each_with_index.map do |state, i|
        text = Spree.t("registration_state.#{state}").titleize
        text.prepend("#{i.succ}. ") if numbers

        css_classes = ['text-uppercase nav-item']
        current_index = states.index(current_state)
        state_index = states.index(state)

        if state_index < current_index
          css_classes << 'completed'
          link_content = content_tag :span, nil, class: 'checkout-progress-steps-image checkout-progress-steps-image--full'
          link_content << text
          text = link_to(link_content, spree.checkout_state_path(state), class: 'd-flex flex-column align-items-center', method: :get)
        end

        css_classes << 'next' if state_index == current_index + 1
        css_classes << 'active' if state == current_state
        css_classes << 'first' if state_index == 0
        css_classes << 'last' if state_index == states.length - 1
        # No more joined classes. IE6 is not a target browser.
        # Hack: Stops <a> being wrapped round previous items twice.
        if state_index < current_index
          content_tag('li', text, class: css_classes.join(' '))
        else
          link_content = if state == current_state
                           content_tag :span, nil, class: 'checkout-progress-steps-image checkout-progress-steps-image--full'
                         else
                           inline_svg_tag 'circle.svg', class: 'checkout-progress-steps-image'
                         end
          link_content << text
          content_tag('li', content_tag('a', link_content, class: "d-flex flex-column align-items-center #{'active' if state == current_state}"), class: css_classes.join(' '))
        end
      end
      content = content_tag('ul', raw(items.join("\n")), class: 'nav justify-content-between checkout-progress-steps', id: "checkout-step-#{current_state}")
      hrs = '<hr />' * (states.length - 1)
      content << content_tag('div', raw(hrs), class: "checkout-progress-steps-line state-#{current_state}")
    end

    def float_label_field(form, method, is_required = false, &handler)
      content_tag :div, id: method, class: 'form-group checkout-content-inner-field has-float-label' do
        if handler
          yield
        else
          method_name = Spree.t(method)
          required = Spree.t(:required)
          form.text_field(method,
                          class: ['spree-flat-input'].compact,
                          required: is_required,
                          placeholder: is_required ? "#{method_name} #{required}" : method_name,
                          aria: { label: method_name }) +
            form.label(method_name,
                       is_required ? "#{method_name} #{required}" : method_name,
                       class: 'text-uppercase')
        end
      end
    end

    def wholesale_product_variants_matrix(is_product_available_in_currency, variants, wholesale)
      Spree::VariantPresenter.new(
        variants: variants,
        is_product_available_in_currency: is_product_available_in_currency,
        current_currency: current_currency,
        current_price_options: current_price_options,
        current_store: current_store,
        wholesale: wholesale
      ).call.to_json
    end

    def wholesale_product_available_in_currency?(product_price)
      !(product_price.nil? || product_price.zero?)
    end

    def wholesale_used_variants_options(variants, product)
      wholesale_variants_option_types_presenter(variants, product).options
    end

    def wholesale_variants_option_types_presenter(variants, product)
      option_types = Spree::Variants::OptionTypesFinder.new(variant_ids: variants.map(&:id)).execute
      Spree::Variants::OptionTypesPresenter.new(option_types, variants, product)
    end

  end
end
