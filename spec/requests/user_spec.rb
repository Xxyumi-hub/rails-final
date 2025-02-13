require 'rails_helper'
RSpec.describe "UsersControllers", type: :request do
    describe "get users_path"do
        it "renders the index view" do
            FactoryBot.create_list(:user, 10)
            get users_path
            expect(response).to render_template(:index)
        end
    end
    describe "get user_path" do
        it "renders the :show view" do
            user = FactoryBot.create(:user)
            get user_path(id: user.id)
            expect(response).to render_template(:show)
        end
        it "redirects to the index path if user id is invalid" do
        get user_path(id: 500)
        expect(response).to redirect_to users_path
        end
    end
    describe "get new_user_path" do
        it "renders the :new template" do
            get new_user_path
            expect(response).to render_template(:new)
        end
    end
    describe "get edit_user_path" do
        it "renders the :edit template" do
            user = FactoryBot.create(:user)
            get edit_user_path(id: user.id)
            expect(response).to render_template(:edit)
        end
    end
    describe "post users_path with valid data" do
        it "saves a new entry and redirects to the show path for the entry" do
            user_attributes = FactoryBot.attributes_for(:user)
            expect { post users_path, params: {user: user_attributes}}.to change(User, :count)
            expect(response).to redirect_to user_path(id: User.last.id)
        end
    end
    describe "post users_path with invalid data" do
        it "does not save a new entry or redirect" do
            user_attributes = FactoryBot.attributes_for(:user)
            user_attributes.delete(:first_name)
            expect { post users_path, params: {user: user_attributes}}.to_not change(User, :count)
            expect(response).to render_template(:new)
        end
    end
    describe "put user_path with valid data" do
        it "updates an entry and redirects to the show path for the customer" do
            user = FactoryBot.create(:user, first_name: "William")
            expect(user.first_name).to eq("William")
            put user_path(user.id), params: {user: {first_name: "Wils"}}
            user.reload
            expect(user.first_name).to eq("Wils")
            expect(response).to redirect_to user_path(id: user.id)
        end
    end
    describe "put user_path with invalid data" do
        it "does not update the user record or redirect" do
            user = FactoryBot.create(:user)
            put user_path(user.id), params: {user: {phone: "222"}}
            user.reload
            expect(user.phone).to_not eq("222")
            expect(response).to render_template(:edit)
        end
    end
    describe "delete a user record" do
        it "deletes a user record" do
            user = FactoryBot.create(:user)
            user.destroy
            expect(get user_path(id: 500))
        end
    end
end