class MatchesController < ApplicationController
  def create
    @player1 = Player.find_by(id: params[:player_1_id])
    @player2 = Player.find_by(id: params[:player_2_id])

    render json: { success: false, message: 'Player 1 is not valid' } and return if @player1.nil?

    render json: { success: false, message: 'Player 2 is not valid' } and return if @player2.nil?

    if params[:player_1_id] == params[:player_2_id]
      render json: { success: false, message: 'Player 1 and Player 2 cannot be the same' } and return
    end

    unless [params[:player_1_id], params[:player_2_id]].include?(params[:winner_id])
      render json: { success: false, message: 'Winner should be either player 1 or player 2' } and return
    end

    @match = Match.new(match_params.merge(scheduled_on: Time.now))
    if @match.save
      render json: { success: true, message: 'Match created successfully', match: @match }
    else
      render json: { success: false, message: "Error in creating match: #{@match.errors.full_messages}", match: nil }
    end
  end

  private

  def match_params
    params.permit(:player_1_id, :player_2_id, :winner_id)
  end
end
