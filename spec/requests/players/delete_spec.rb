require 'rails_helper'

RSpec.describe 'Players API', type: :request do
  describe 'DELETE /players/:id' do
    context 'Success cases' do
      it 'Should update name' do
        player = create(:player)
        delete "/players/#{player.id}"

        json_response = JSON.parse(response.body)
        expect(json_response['success']).to eq true
        expect(json_response['message']).to include('Player deleted successfully')
      end
    end
  end
end
