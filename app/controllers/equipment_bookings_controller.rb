class EquipmentBookingsController < ApplicationController
    def new
        @equipment_booking = EquipmentBooking.new
        @show = Show.find(params[:show_id])
    end

    def create
        @show = Show.find(eb_params[:show_id])
        @equipment_booking = EquipmentBooking.create(eb_params)
        return render :new unless @equipment_booking.save
        redirect_to show_path(eb_params[:show_id])
    end

    def destroy
        equipment_booking = EquipmentBooking.find(params[:id])
        show = equipment_booking.show
        equipment_booking.destroy
        redirect_to show_path(show)
    end

    def increment
        equipment_booking = EquipmentBooking.find(params[:id])
        equipment_booking.quantity = equipment_booking.quantity.to_i + params[:increment].to_i
        equipment_booking.save
        redirect_to show_path(equipment_booking.show)
    end

    private

    def eb_params
        params.require(:equipment_booking).permit(:equipment_id, :show_id, :quantity)
    end
end
