require 'rails_helper'

RSpec.describe 'Matches API', type: :request do
  describe 'POST /matches' do
    context 'Failure case' do
      it 'Should fail when player 1 is invalid' do
        player1 = create(:player, name: 'Player 1')
        player2 = create(:player, name: 'Player 2')
        post '/matches', params: { player_1_id: player1.id + 10_000, player_2_id: player2.id, winner_id: player1.id }

        json_response = JSON.parse(response.body)
        expect(json_response['success']).to eq false
        expect(json_response['message']).to include('Player 1 is not valid')
        expect(json_response['match']).to be_nil
      end

      it 'Should fail when player 2 is invalid' do
        player1 = create(:player, name: 'Player 1')
        player2 = create(:player, name: 'Player 2')
        post '/matches', params: { player_1_id: player1.id, player_2_id: player2.id + 10_000, winner_id: player1.id }

        json_response = JSON.parse(response.body)
        expect(json_response['success']).to eq false
        expect(json_response['message']).to include('Player 2 is not valid')
        expect(json_response['match']).to be_nil
      end

      it 'Should fail when player 1 and player 2 are the same' do
        player1 = create(:player, name: 'Player 1')
        post '/matches', params: { player_1_id: player1.id, player_2_id: player1.id, winner_id: player1.id }

        json_response = JSON.parse(response.body)
        expect(json_response['success']).to eq false
        expect(json_response['message']).to include('Player 1 and Player 2 cannot be the same')
        expect(json_response['match']).to be_nil
      end

      it 'Should fail when winner ID is invalid' do
        player1 = create(:player, name: 'Player 1')
        player2 = create(:player, name: 'Player 2')
        post '/matches', params: { player_1_id: player1.id, player_2_id: player2.id, winner_id: player1.id - 1 }

        json_response = JSON.parse(response.body)
        expect(json_response['success']).to eq false
        expect(json_response['message']).to include('Winner should be either player 1 or player 2')
        expect(json_response['match']).to be_nil
      end
    end

    context 'Success case' do
      it 'Should create a match record properly' do
        player1 = create(:player, name: 'Player 1')
        player2 = create(:player, name: 'Player 2')
        post '/matches', params: { player_1_id: player1.id, player_2_id: player2.id, winner_id: player1.id }

        json_response = JSON.parse(response.body)
        expect(json_response['success']).to eq true
        expect(json_response['message']).to include('Match created successfully')
        expect(json_response['match']).not_to be_nil
        expect(json_response['match']['player_1_id']).to eq player1.id
        expect(json_response['match']['player_2_id']).to eq player2.id
        expect(json_response['match']['winner_id']).to eq player1.id
      end
    end
  end
end
