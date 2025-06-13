require 'rails_helper'

RSpec.describe 'ProjectMemberships API', type: :request do
  let(:owner)   { create(:user) }
  let(:invitee) { create(:user) }
  let(:project) { create(:project, user: owner) }

  let!(:owner_membership) { create(:project_membership, user: owner, project: project, role: 'owner') }

  describe 'POST /api/v1/projects/:project_id/project_memberships' do
    let(:params) { { project_membership: { user_id: invitee.id, role: 'member' } }.to_json }

    it 'owner can invite a new member' do
      expect {
        post "/api/v1/projects/#{project.id}/project_memberships",
             params:  params,
             headers: auth_cookie_for(owner)
      }.to change(ProjectMembership, :count).by(1)

      expect(response).to have_http_status(:created)
      body = JSON.parse(response.body)
      expect(body['user_id']).to eq(invitee.id)
      expect(body['role']).to eq('member')
    end
  end

  describe 'PATCH /api/v1/projects/:project_id/project_memberships/:id' do
    let!(:membership) { create(:project_membership, user: invitee, project: project, role: 'member') }
    let(:params)      { { project_membership: { role: 'admin' } }.to_json }

    it 'owner can promote a member to admin' do
      patch "/api/v1/projects/#{project.id}/project_memberships/#{membership.id}",
            params: params,
            headers: auth_cookie_for(owner)

      expect(response).to have_http_status(:ok)
      expect(membership.reload.role).to eq('admin')
    end
  end

  describe 'DELETE /api/v1/projects/:project_id/project_memberships/:id' do
    let!(:membership) { create(:project_membership, user: invitee, project: project, role: 'member') }

    it 'owner can remove a member' do
      delete "/api/v1/projects/#{project.id}/project_memberships/#{membership.id}",
             headers: auth_cookie_for(owner)

      expect(response).to have_http_status(:no_content)
      expect(ProjectMembership.exists?(membership.id)).to be_falsey
    end
  end
end
