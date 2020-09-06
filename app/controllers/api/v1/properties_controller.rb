module Api
    module V1
        class PropertiesController < ApplicationController
            before_action :authorize_request, except: [:index, :show, :search]
            before_action :set_page, only: [:index]
            
            # add a new listing
            def create
                # upload all selected images to cloudinary
                @files_length = property_params['property_images'].length - 1
                @uploaded_files = []
                @len = @uploaded_files.length - 1

                for i in 0..@files_length do
                    @file_path = property_params['property_images'][i]
                    @uploaded = Cloudinary::Uploader.upload(@file_path)

                    if @uploaded
                        @uploaded_files.push(@uploaded['url'])
                    end
                end
                # save listing to database with urls to uploaded images
                result = @current_user.properties.create(
                    title: property_params['title'],
                    description: property_params['description'],
                    price: property_params['price'],
                    category: property_params['category'],
                    property_type: property_params['property_type'],
                    location: property_params['location'],
                    size: property_params['size'],
                    property_images: @uploaded_files
                )
                if result.valid? # successfuly saved to database
                    render json: {
                        success: true,
                        message: 'Property successfuly listed',
                        data: result
                    }, status: 201
                else 
                    render json: {
                        success: false,
                        error: 'Unable to add property',
                    }, status: 500
                end
            end

            # get all listings
            def index
                properties = Property.order(created_at: :desc).limit(12).offset(@page * 12)
                if properties.length === 0
                    render json: {
                        success: true,
                        message: 'There are no listings at the moment. Please check back later. Thank you.',
                        data: properties
                    }, status: 200
                else
                    render json: {
                        success: true,
                        message: 'All Listings',
                        data: properties
                    }, status: 200
                end
            end

            def search
                result = Property.where("category = ? AND location = ? ", params[:category], params[:location]).order(created_at: :desc)
                render json: {
                    success: true,
                    message: "Found #{result.length} listings for your search",
                    data: result
                }
            end

            # get single listing
            def show
                property = Property.find(params[:id])
        
                render json: {
                    success: true,
                    data: property,
                    realtor: {
                        name: property.user.name,
                        email: property.user.email,
                        phone: property.user.phone_number,
                        office_address: property.user.office_address,
                        profile_picture: property.user.profile_picture
                    }
                }, status: 200

                rescue ActiveRecord::RecordNotFound => e
                    render json: {
                        error: e.to_s,
                    }, status: :not_found
            end

            # fetch all user only listings
            def user_listings
                result = @current_user.properties
                if result.length == 0
                    render json: {
                        success: true,
                        message: 'You do not have any listing yet.'
                    }, status: 200
                else 
                    render json: {
                        success: true,
                        data: result
                    }, status: 200
                end
            end

            # edit listing
            def update
                property = Property.find(params[:id])
                # ensure only the user who added the property has the right to update it
                if @current_user.id != property.user_id
                    render json: {
                        success: false,
                        error: 'Unauthorized',
                    }, status: 401
                    
                   return
                end
                # if property is set as rent, change status to rented
                if property.category === 'rent' && property.status === 'available'
                    property.status = 'rented'
                    property.save

                    render json: {
                        success: true,
                        message: "Listing successfuly updated",
                    }, status: 200

                    return
                end
                # if property is set as buy, change status to bought
                if property.category === 'buy' && property.status === 'available'
                    property.status = 'bought'
                    property.save
                    render json: {
                        success: true,
                        message: "Listing successfuly updated",
                        data: property
                    }, status: 200
                    return
                end

                rescue ActiveRecord::RecordNotFound => e
                    render json: {
                        error: e.to_s,
                    }, status: :not_found
            end

            # delete listing
            def destroy
                property = Property.find(params[:id])
                # ensure only the user who added the property has the right to update it
                if @current_user.id != property.user_id
                    render json: {
                        success: false,
                        error: 'Unauthorized',
                    }, status: 401
                    
                   return
                end
                # delete property and return success message
                property.destroy
                render json: {
                    success: true,
                    message: "Listing deleted"
                }, status: 200

                rescue ActiveRecord::RecordNotFound => e
                    render json: {
                        error: e.to_s,
                    }, status: :not_found
                
            end

    
            private
            def property_params
                params.permit(:title, :description, :price, :property_type, :category, :location, :size, :property_images => [])
            end
            def set_page
                @page = params[:page] || 0
              end

        end
    end
end

