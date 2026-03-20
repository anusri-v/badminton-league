require 'rails_helper'

RSpec.describe 'Players API', type: :request do
  describe 'GET /players/:id' do
    context 'Failure cases' do
      it 'When player ID is invalid' do
        player = create(:player)
        get "/players/#{player.id + 10_000}"

        json_response = JSON.parse(response.body)
        expect(json_response['success']).to eq false
        expect(json_response['message']).to include('Invalid player')
        expect(json_response['player']).to be_nil
        expect(json_response['wins']).to eq nil
        expect(json_response['losses']).to eq nil
      end
    end

    context 'Success cases' do
      it 'Return player data' do
        player = create(:player)
        player1 = create(:player)
        player2 = create(:player)
        player3 = create(:player)
        create(:match, player_1_id: player.id, player_2_id: player1.id, winner_id: player.id)
        create(:match, player_1_id: player.id, player_2_id: player2.id, winner_id: player2.id)
        create(:match, player_1_id: player.id, player_2_id: player3.id, winner_id: player.id)
        create(:match, player_1_id: player.id, player_2_id: player1.id, winner_id: player.id)
        get "/players/#{player.id}"

        json_response = JSON.parse(response.body)
        expect(json_response['success']).to eq true
        expect(json_response['message']).to include('Player data fetched successfully')
        expect(json_response['player']).not_to be_nil
        expect(json_response['player']['id']).to eq player.id
        expect(json_response['player']['name']).to eq player.name
        expect(json_response['player']['email']).to eq player.email
        expect(json_response['player']['phone']).to eq player.phone
        expect(json_response['player']['gender']).to eq player.gender
        expect(json_response['wins']).to eq 3
        expect(json_response['losses']).to eq 1
      end
    end
  end
end
