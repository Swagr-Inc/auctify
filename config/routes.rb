# frozen_string_literal: true

Auctify::Engine.routes.draw do
  namespace :auctify do
    resources :sales_packs
    resources :bids
    resources :bidder_registrations
    resources :sales

    namespace :api do
      namespace :v1 do
        resources :auctions do
          member do
            resources :bids
          end
        end
      end
    end
  end
end
