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

  def index
    @players = Player.all
    @players = @players.order('id DESC')
    @players = @players.where('name like (?)', "%#{params[:name]}%") if params[:name].present?
    @players = @players.where('email like (?)', "%#{params[:email]}%") if params[:email].present?
    @players = @players.where(phone: params[:phone]) if params[:phone].present?
    @players = @players.where(gender: params[:gender]) if params[:gender].present?
    count = @players.count

    page     = (params[:page] || 1).to_i
    per_page = (params[:per_page] || 10).to_i
    offset   = (page - 1) * per_page

    if params[:leaderboard]
      @players = @players.joins('LEFT JOIN matches ON matches.winner_id = players.id')
                         .select('players.*, COUNT(matches.winner_id) AS win_count')
                         .group('players.id')
                         .order('win_count DESC')
                         .limit(per_page).offset(offset)

      render json: { success: true, players: @players.as_json(methods: [:win_count]), count: count, page: page.to_i, per_page: per_page.to_i } and return
    end

    @players = @players.limit(per_page).offset(offset)
    render json: { success: true, players: @players, count: count, page: page.to_i, per_page: per_page.to_i }
  end

  def show
    render json: { success: false, message: 'Player ID cannot be blank', player: nil } and return unless params[:id].present?

    @player = Player.find_by(id: params[:id])
    render json: { success: false, message: 'Invalid player', player: nil } and return if @player.nil?

    render json: {
      success: true,
      message: 'Player data fetched successfully',
      player: @player,
      wins: @player.win_count,
      losses: @player.loss_count
    }
  end

  private

  def player_params
    params.permit(:name, :email, :phone, :gender)
  end
end
