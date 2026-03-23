class MatchesController < ApplicationController
  def new
    @players = Player.all.order(:name)
  end

  def create
    @player1 = Player.find_by(id: params[:player_1_id])
    @player2 = Player.find_by(id: params[:player_2_id])

    @players = Player.all.order(:name)
    @error = nil

    if @player1.nil?
      @error = 'Player 1 is not valid'
    elsif @player2.nil?
      @error = 'Player 2 is not valid'
    elsif params[:player_1_id] == params[:player_2_id]
      @error = 'Player 1 and Player 2 cannot be the same'
    elsif ![params[:player_1_id], params[:player_2_id]].include?(params[:winner_id])
      @error = 'Winner should be either player 1 or player 2'
    end

    if @error
      respond_to do |format|
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: { success: false, message: @error } }
      end
      return
    end

    @match = Match.new(match_params.merge(scheduled_on: Time.now))
    respond_to do |format|
      if @match.save
        format.html { redirect_to root_path, notice: 'Match recorded successfully' }
        format.json { render json: { success: true, message: 'Match created successfully', match: @match } }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: { success: false, message: "Error in creating match: #{@match.errors.full_messages}", match: nil } }
      end
    end
  end

  private

  def match_params
    params.permit(:player_1_id, :player_2_id, :winner_id)
  end
end
