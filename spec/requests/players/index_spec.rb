require 'rails_helper'

RSpec.describe 'Players API', type: :request do
  describe 'GET /players' do
    context 'Success cases' do
      let!(:player1) do
        create(:player, name: 'player1', email: 'player1@gmail.com', phone: '9087654321', gender: 'female')
      end
      let!(:player2) do
        create(:player, name: 'player2', email: 'player2@gmail.com', phone: '9087654322', gender: 'female')
      end
      let!(:player3) do
        create(:player, name: 'player3', email: 'player3@gmail.com', phone: '9087654323', gender: 'male')
      end
      let!(:player4) do
        create(:player, name: 'player4', email: 'player4@gmail.com', phone: '9087654324', gender: 'male')
      end
      let!(:player5) do
        create(:player, name: 'player5', email: 'player5@gmail.com', phone: '9087654325', gender: 'male')
      end

      it 'Returns all data when no filter is applied' do
        get '/players'

        json_response = JSON.parse(response.body)
        expect(json_response['success']).to eq true
        expect(json_response['count']).to eq 5
        expect(json_response['page']).to eq 1
        expect(json_response['per_page']).to eq 10

        expect(json_response['players'][0]['id']).to eq player5.id
        expect(json_response['players'][0]['name']).to eq player5.name
        expect(json_response['players'][0]['email']).to eq player5.email
        expect(json_response['players'][0]['phone']).to eq player5.phone
        expect(json_response['players'][0]['gender']).to eq player5.gender

        expect(json_response['players'][1]['id']).to eq player4.id
        expect(json_response['players'][1]['name']).to eq player4.name
        expect(json_response['players'][1]['email']).to eq player4.email
        expect(json_response['players'][1]['phone']).to eq player4.phone

        expect(json_response['players'][2]['id']).to eq player3.id
        expect(json_response['players'][2]['name']).to eq player3.name
        expect(json_response['players'][2]['email']).to eq player3.email
        expect(json_response['players'][2]['phone']).to eq player3.phone

        expect(json_response['players'][3]['id']).to eq player2.id
        expect(json_response['players'][3]['name']).to eq player2.name
        expect(json_response['players'][3]['email']).to eq player2.email
        expect(json_response['players'][3]['phone']).to eq player2.phone

        expect(json_response['players'][4]['id']).to eq player1.id
        expect(json_response['players'][4]['name']).to eq player1.name
        expect(json_response['players'][4]['email']).to eq player1.email
        expect(json_response['players'][4]['phone']).to eq player1.phone
      end

      it 'Returns relevant data when name filter is applied' do
        get '/players', params: { name: 'player1' }

        json_response = JSON.parse(response.body)
        expect(json_response['success']).to eq true
        expect(json_response['count']).to eq 1
        expect(json_response['page']).to eq 1
        expect(json_response['per_page']).to eq 10
        expect(json_response['players'][0]['id']).to eq player1.id
      end

      it 'Returns relevant data when email filter is applied' do
        get '/players', params: { email: 'player3' }

        json_response = JSON.parse(response.body)
        expect(json_response['success']).to eq true
        expect(json_response['count']).to eq 1
        expect(json_response['page']).to eq 1
        expect(json_response['per_page']).to eq 10
        expect(json_response['players'][0]['id']).to eq player3.id
      end

      it 'Returns relevant data when phone filter is applied' do
        get '/players', params: { phone: '9087654324' }

        json_response = JSON.parse(response.body)
        expect(json_response['success']).to eq true
        expect(json_response['count']).to eq 1
        expect(json_response['page']).to eq 1
        expect(json_response['per_page']).to eq 10
        expect(json_response['players'][0]['id']).to eq player4.id
      end

      it 'Returns relevant data when gender filter is applied' do
        get '/players', params: { gender: 'female' }

        json_response = JSON.parse(response.body)
        expect(json_response['success']).to eq true
        expect(json_response['count']).to eq 2
        expect(json_response['page']).to eq 1
        expect(json_response['per_page']).to eq 10
        expect(json_response['players'][0]['id']).to eq player2.id
        expect(json_response['players'][1]['id']).to eq player1.id
      end

      it 'Returns relevant data when pagination is applied' do
        get '/players', params: { page: 2, per_page: 2 }

        json_response = JSON.parse(response.body)
        expect(json_response['success']).to eq true
        expect(json_response['count']).to eq 5
        expect(json_response['page']).to eq 2
        expect(json_response['per_page']).to eq 2
        expect(json_response['players'][0]['id']).to eq player3.id
        expect(json_response['players'][1]['id']).to eq player2.id
      end

      context 'When Leaderboard param is true' do
        let!(:match1) { create(:match, player_1_id: player1.id, player_2_id: player2.id, winner_id: player1.id) }
        let!(:match2) { create(:match, player_1_id: player2.id, player_2_id: player3.id, winner_id: player2.id) }
        let!(:match3) { create(:match, player_1_id: player3.id, player_2_id: player4.id, winner_id: player3.id) }
        let!(:match4) { create(:match, player_1_id: player4.id, player_2_id: player2.id, winner_id: player2.id) }
        let!(:match5) { create(:match, player_1_id: player5.id, player_2_id: player1.id, winner_id: player5.id) }
        let!(:match6) { create(:match, player_1_id: player1.id, player_2_id: player2.id, winner_id: player1.id) }
        let!(:match7) { create(:match, player_1_id: player2.id, player_2_id: player3.id, winner_id: player2.id) }

        it 'Returns relevant data' do
          get '/players', params: { leaderboard: true }

          json_response = JSON.parse(response.body)
          expect(json_response['success']).to eq true
          expect(json_response['count']).to eq 5
          expect(json_response['page']).to eq 1
          expect(json_response['per_page']).to eq 10
          expect(json_response['players'][0]['id']).to eq player5.id
          expect(json_response['players'][0]['win_count']).to eq 1

          expect(json_response['players'][1]['id']).to eq player4.id
          expect(json_response['players'][1]['win_count']).to eq 0

          expect(json_response['players'][2]['id']).to eq player3.id
          expect(json_response['players'][2]['win_count']).to eq 1

          expect(json_response['players'][3]['id']).to eq player2.id
          expect(json_response['players'][3]['win_count']).to eq 3

          expect(json_response['players'][4]['id']).to eq player1.id
          expect(json_response['players'][4]['win_count']).to eq 2
        end
      end
    end
  end
end
