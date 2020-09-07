require 'mailgun-ruby'
require_relative 'json_web_token'

module Api
    module V1
        class UsersController < ApplicationController
            def welcome
                render json: {
                    message: 'Welcome. View the api docs at the link below',
                    api_doc: "https://documenter.getpostman.com/view/6511530/TVCiSRVd"
                }
            end
            # user registration method
            def create
                user = User.new(user_params)
                if user.valid?   # user creation was successful
                    # upload profile picture and save url to db
                    image = Cloudinary::Uploader.upload(user_params['profile_picture'])
                    user.profile_picture = image['secure_url']
                    user.save
                    # send an email to verify email address
                    # confirm_token = SecureRandom.urlsafe_base64(5, false)
                    # user.confirm_token = confirm_token
                    # user.save
                    # url = "#{request.original_url}/verify_email/#{confirm_token}"

                    # mg_client = Mailgun::Client.new(ENV['MAILGUN_SECRET'])
                    # mb_obj = Mailgun::MessageBuilder.new
                    # mb_obj.from("pureheart-find-a-house@app.com")
                    # mb_obj.add_recipient(:to, user.email)
                    # mb_obj.subject("Email Confirmation")
                    # mb_obj.body_html(
                    #     "<html><body>
                    #     <p>Hello #{user.name}, </p> <br>
                    #     <p>Please click on the link below to verify your email address</p> <br>
                    #     <a href=#{url}>#{url}</a> <br><br>
                    #     <p>Thanks</p>
                    #     </body></html>"
                    # )
                    # mg_client.send_message(ENV['MAILGUN_DOMAIN'], mb_obj).to_h!
                    render json: {
                        success: true,
                        message: "Account successfully created. You can now login with your email and password"
                    }, status: 201
                else
                    render json: {
                        success: false,
                        errors: user.errors,
                    }, status: 400
                end 
            end

            def verify_email
                user = User.find_by(confirm_token: params[:token])
                if user
                    user.confirm_token = nil
                    user.save!
                    user.email_confirmed = true
                    user.save!
                  
                    # render json: {
                    #     success: true,
                    #     message: 'Account successfuly verified. You can now login'    
                    # }, status: 200

                    redirect_to 'https://pureheart-find-a-house-admin.netlify.app/login.html' 
                    return
                else
                    render json: {
                        success: false,
                        error: 'Invalid user token'
                    }, status: 404
                end
            end

            def login
                # ensure user enters email and password
                if !login_params[:email].present? || !login_params[:password].present?
                    render json: {
                        success: false,
                        error: "Please fill all fields"
                    }, status: 400

                    return
                end
                # find the user by email and check if the user exists
                user = User.find_by_email(login_params[:email])
                if !user
                    render json: {
                        success: false,
                        error: "Invalid credentials"
                    }, status: 400

                    return
                end
                # if user is found, check if user has confirmed email
                # if !user.email_confirmed
                #     render json: {
                #         success: false,
                #         error: "Kindly confirm your email before login"
                #     }, status: 400

                #     return
                # end
                # if user is confirmed, authenticate with password, generate and return a jwt
                @authenticated_user = user.authenticate(login_params[:password])
                if @authenticated_user
                    token = Api::V1::JsonWebToken.encode(user_id: @authenticated_user.id)
                
                    render json: { 
                        success: true,
                        message: "User login successful",
                        token: token, 
                        user: @authenticated_user.name
                    }, status: 200
                    
                    return
                else 
                    # return unauthorized if user is not authenticated
                    render json: { 
                        success: false,
                        error: "Invalid credentials",
                    }, status: 401

                    return
                end
            end

            private
            def user_params
                params.permit(:name, :email, :password, :password_confirmation, :office_address, :phone_number, :profile_picture)
            end

            def login_params
                params.permit(:email, :password)
            end
        
        end
    end
end

