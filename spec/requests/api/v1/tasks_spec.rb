require 'rails_helper'

RSpec.describe 'Tasks API', type: :request do
  let(:owner)   { create(:user) }
  let(:member)  { create(:user) }
  let(:stranger) { create(:user) }

  let(:project) { create(:project, user: owner) }
  let!(:owner_membership)   { create(:project_membership, user: owner,   project: project, role: 'owner') }
  let!(:member_membership)  { create(:project_membership, user: member,  project: project, role: 'member') }

  describe 'POST /api/v1/projects/:project_id/tasks' do
    let(:params) { { task: { title: 'Write docs', description: 'API docs', status: 'pending', priority: 'low' } }.to_json }

    it 'allows any project member to create a task' do
      expect {
        post "/api/v1/projects/#{project.id}/tasks",
             params:  params,
             headers: auth_cookie_for(member)
      }.to change(Task, :count).by(1)

      expect(response).to have_http_status(:created)
      expect(JSON.parse(response.body)['title']).to eq('Write docs')
    end

    it 'forbids non-members' do
      post "/api/v1/projects/#{project.id}/tasks",
           params: params,
           headers: auth_cookie_for(stranger)

      expect(response).to have_http_status(:forbidden)
    end
  end

  describe 'DELETE /api/v1/projects/:project_id/tasks/:id' do
    let!(:task) { create(:task, project: project, creator: owner) }

    it 'allows owner/admin to delete' do
      delete "/api/v1/projects/#{project.id}/tasks/#{task.id}",
             headers: auth_cookie_for(owner)

      expect(response).to have_http_status(:no_content)
      expect(Task.exists?(task.id)).to be_falsey
    end

    it 'blocks regular members' do
      delete "/api/v1/projects/#{project.id}/tasks/#{task.id}",
             headers: auth_cookie_for(member)

      expect(response).to have_http_status(:forbidden)
    end
  end
end
