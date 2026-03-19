require 'rails_helper'

RSpec.describe 'Players API', type: :request do
  describe 'POST /players' do
    context 'Failure cases' do
      it 'Should fail when email is invalid' do
        post '/players', params: { name: 'Player', email: 'player@example', phone: '9087654321' }

        json_response = JSON.parse(response.body)
        expect(json_response['success']).to eq false
        expect(json_response['message']).to include('Email is invalid')
        expect(json_response['player']).to be nil
      end

      it 'Should fail when phone is invalid' do
        post '/players', params: { name: 'Player', email: 'player@example.com', phone: '908765432' }

        json_response = JSON.parse(response.body)
        expect(json_response['success']).to eq false
        expect(json_response['message']).to include('Phone is invalid')
        expect(json_response['player']).to be_nil
      end

      it 'Should fail when phone is invalid' do
        post '/players', params: { name: 'Player', email: 'player@example.com', phone: '9087a65432' }

        json_response = JSON.parse(response.body)
        expect(json_response['success']).to eq false
        expect(json_response['message']).to include('Phone is invalid')
        expect(json_response['player']).to be_nil
      end
    end

    context 'Success case' do
      it 'Should create a player record properly' do
        post '/players', params: { name: 'Player', email: 'player@example.com', phone: '9087654321' }

        json_response = JSON.parse(response.body)
        expect(json_response['success']).to eq true
        expect(json_response['message']).to include('Player created successfully')
        expect(json_response['player']).not_to be_nil
      end
    end
  end
end
