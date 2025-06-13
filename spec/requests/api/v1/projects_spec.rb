require 'rails_helper'

RSpec.describe 'Projects API', type: :request do
  let(:owner)   { create(:user) }
  let(:project) { create(:project) }
  let!(:membership) { create(:project_membership, user: owner, project: project, role: 'owner') }

  describe 'GET /api/v1/projects' do
    it 'returns projects the user is a member of' do
      get '/api/v1/projects', headers: auth_cookie_for(owner)

      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)

      expect(json.map{ |p| p['id'] }).to include(project.id)
    end
  end

  describe 'POST /api/v1/projects' do
    let(:params) { { project: { name: 'New Project',
                                description: 'Demo',
                                deadline: 1.week.from_now } }.to_json }

    it 'creates a new project' do
      expect {
        post '/api/v1/projects',
             params: params,
             headers: auth_cookie_for(owner)
      }.to change(Project, :count).by(1)
      expect(response).to have_http_status(:created)
    end

    it 'assigns owner membership' do
      expect {
        post '/api/v1/projects',
           params: params,
           headers: auth_cookie_for(owner)
      }.to change(ProjectMembership.where(user: owner, role: 'owner'), :count).by(1)
    end
  end

  describe 'DELETE /api/v1/projects/:id' do
    context 'as owner' do
      it 'destroys the project' do
        expect {
          delete "/api/v1/projects/#{project.id}", headers: auth_cookie_for(owner)
        }.to change(Project, :count).by(-1)
        expect(response).to have_http_status(:no_content)
      end
    end

    context 'as non-member' do
      let(:stranger) { create(:user) }

      it 'is forbidden' do
        delete "/api/v1/projects/#{project.id}", headers: auth_cookie_for(stranger)
        expect(response).to have_http_status(:forbidden)
        expect(JSON.parse(response.body)['error']).to eq('You are not authorized to perform this action.')
      end
    end
  end
end
