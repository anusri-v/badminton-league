class PlayersController < ApplicationController
  def create
    @player = Player.new(name: params[:name], email: params[:email], phone: params[:phone], gender: params[:gender])
    if @player.save
      render json: { success: true, message: 'Player created successfully', player: @player }
    else
      render json: { success: false, message: "Error in creating player: #{@player.errors.full_messages}", player: nil }
    end
  end

  def update
    render json: { success: false, message: 'Player ID cannot be blank' } and return unless params[:id].present?

    @player = Player.find_by(id: params[:id])
    if @player.update(player_params)
      render json: { success: true, message: 'Player updated successfully', player: @player }
    else
      render json: { success: false, message: "Error in updating player: #{@player.errors.full_messages}", player: @player }
    end
  end

  def destroy
    render json: { success: false, message: 'Player ID cannot be blank' } and return unless params[:id].present?

    @player = Player.find_by(id: params[:id])
    if @player.destroy
      render json: { success: true, message: 'Player deleted successfully' }
    else
      render json: { success: false, message: "Error in deleting player: #{@player.errors.full_messages}" }
    end
  end

  private

  def player_params
    params.permit(:name, :email, :phone, :gender)
  end
end
