require 'rails_helper'

RSpec.describe 'Players API', type: :request do
  describe 'PUT /players/:id' do
    context 'Success cases' do
      it 'Should update name' do
        player = create(:player)
        put "/players/#{player.id}", params: { name: 'Player1' }

        json_response = JSON.parse(response.body)
        expect(json_response['success']).to eq true
        expect(json_response['message']).to include('Player updated successfully')
        expect(json_response['player']).not_to be_nil
        expect(json_response['player']['name']).to eq 'Player1'
      end

      it 'Should update email' do
        player = create(:player)
        put "/players/#{player.id}", params: { email: 'player1@gmail.com' }

        json_response = JSON.parse(response.body)
        expect(json_response['success']).to eq true
        expect(json_response['message']).to include('Player updated successfully')
        expect(json_response['player']).not_to be_nil
        expect(json_response['player']['email']).to eq 'player1@gmail.com'
      end

      it 'Should update phone' do
        player = create(:player)
        put "/players/#{player.id}", params: { phone: '8901234567' }

        json_response = JSON.parse(response.body)
        expect(json_response['success']).to eq true
        expect(json_response['message']).to include('Player updated successfully')
        expect(json_response['player']).not_to be_nil
        expect(json_response['player']['phone']).to eq '8901234567'
      end

      it 'Should update multiple params' do
        player = create(:player)
        put "/players/#{player.id}", params: { name: 'Player1', email: 'player1@gmail.com', phone: '8901234567' }

        json_response = JSON.parse(response.body)
        expect(json_response['success']).to eq true
        expect(json_response['message']).to include('Player updated successfully')
        expect(json_response['player']).not_to be_nil
        expect(json_response['player']['name']).to eq 'Player1'
        expect(json_response['player']['email']).to eq 'player1@gmail.com'
        expect(json_response['player']['phone']).to eq '8901234567'
      end
    end
  end
end
