require 'mailgun-ruby'
require_relative 'json_web_token'

module Api
    module V1
        class PropertiesController < ApplicationController
            before_action :authorize_request, except: :index
            # add a new listing
            def create
                render json: {
                    message: 'Add a new listing'
                }
            end

            def index
                render json: {
                    message: 'ALL LISTINGS'
                }
            end


    
            private
            def property_params
                params.permit(:name, :email, :password, :password_confirmation, :office_address, :phone_number, :profile_picture)
            end

        end
    end
end

