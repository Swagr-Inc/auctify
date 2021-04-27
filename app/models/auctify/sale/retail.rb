# frozen_string_literal: true

module Auctify
  module Sale
    class Retail < Auctify::Sale::Base
      include AASM

      aasm do
        state :offered, initial: true, color: "red"
        state :accepted, color: "red"
        state :refused, color: "dark"
        state :in_sale, color: "yellow"
        state :sold, color: "green"
        state :not_sold, color: "dark"
        state :cancelled, color: "red"

        event :accept_offer do
          transitions from: :offered, to: :accepted
        end

        event :refuse_offer do
          transitions from: :offered, to: :refused
        end

        event :start_sale do
          transitions from: :accepted, to: :in_sale
        end

        event :sell do
          transitions from: :in_sale, to: :sold
          after do |*args| # TODO: sold_at
            params = args.first # expecting keys :buyer, :price
            self.buyer = params[:buyer]
            self.sold_price = params[:price]
          end
        end

        event :end_sale do
          transitions from: :in_sale, to: :not_sold
        end

        event :cancel do
          transitions from: [:offered, :accepted], to: :cancelled
        end
      end
    end
  end
end

# == Schema Information
#
# Table name: auctify_sales
#
#  id                :bigint(8)        not null, primary key
#  seller_type       :string           not null
#  seller_id         :integer          not null
#  buyer_type        :string
#  buyer_id          :integer
#  item_id           :integer          not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  type              :string           default("Auctify::Sale::Base")
#  aasm_state        :string           default("offered"), not null
#  published_at      :datetime
#  offered_price     :decimal(, )
#  current_price     :decimal(, )
#  sold_price        :decimal(, )
#  bid_steps_ladder  :json
#  reserve_price     :decimal(, )
#  pack_id           :bigint(8)
#  ends_at           :datetime
#  position          :integer
#  number            :string
#  currently_ends_at :datetime
#
# Indexes
#
#  index_auctify_sales_on_buyer_type_and_buyer_id    (buyer_type,buyer_id)
#  index_auctify_sales_on_pack_id                    (pack_id)
#  index_auctify_sales_on_position                   (position)
#  index_auctify_sales_on_published_at               (published_at)
#  index_auctify_sales_on_seller_type_and_seller_id  (seller_type,seller_id)
#
