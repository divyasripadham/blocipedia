require 'rails_helper'
include RandomData

RSpec.describe WikisController, type: :controller do
  include Devise::TestHelpers

  let(:my_user) { User.create!(email: 'testmember@example.com', password: 'helloworld', username: 'testmember') }
  let(:other_user) { User.create!(email: 'test2member@example.com', password: 'helloworld', username: 'test2member') }
  let(:premium_user) { User.create!(email: 'test3member@example.com', password: 'helloworld', username: 'test3member', role: :premium) }
  let(:my_wiki) { Wiki.create!(title: 'My Wiki', body: 'Wiki body', user: my_user) }
  let(:my_private_wiki) { Wiki.create!(title: 'My Private Wiki', body: 'Private Wiki body', private: true, user: premium_user) }
  let(:my_collaborator) { Collaborator.create!(wiki: my_private_wiki, user: other_user) }

  context "guest" do
    describe "GET Index" do
      it "assigns Wiki.all to Wiki" do
        get :index
        expect(assigns(:wikis)).to eq([my_wiki])
      end

      # it "does not include private topics in @topics" do
      #   get :index
      #   expect(assigns(:topics)).not_to include(my_private_topic)
      # end
    end
    describe "GET show" do

      it "renders the #show view" do
        get :show, {id: my_wiki.id}
        expect(response).to render_template :show
      end

      it "assigns my_wiki to @wiki" do
        get :show, {id: my_wiki.id}
        expect(assigns(:wiki)).to eq(my_wiki)
      end
    end

    describe "GET new" do
      it "returns http redirect" do
        get :new
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    describe "POST create" do
     it "returns http redirect" do
       post :create, wiki: {title: RandomData.random_sentence, body: RandomData.random_paragraph, user: my_user}
       expect(response).to redirect_to(new_user_session_path)
     end
    end

    describe "GET edit" do
     it "returns http redirect" do
       get :edit, {id: my_wiki.id}
       expect(response).to redirect_to(new_user_session_path)
     end
    end

    describe "PUT update" do
     it "returns http redirect" do
       new_title = RandomData.random_sentence
       new_body = RandomData.random_paragraph

       put :update, id: my_wiki.id, topic: {title: new_title, body: new_body }
       expect(response).to redirect_to(new_user_session_path)
     end
    end

    describe "DELETE destroy" do
     it "returns http redirect" do
       delete :destroy, {id: my_wiki.id}
       expect(response).to redirect_to(new_user_session_path)
     end
    end

  end

  context "standard user who is a collaborator on other private wikis" do

    before do
      sign_in other_user
    end

    describe "GET Index" do
      it "assigns Wiki.all to Wiki" do
        private_wiki = Wiki.create!( title: 'My Private Wiki', 
                                     body: 'Private Wiki body', 
                                     private: true, 
                                     user: premium_user)
                                     
        Collaborator.create!(wiki: private_wiki, user: other_user)
        
        get :index
        
        expect(assigns(:wikis)).to include(private_wiki)
      end
    end

    describe "GET show" do
      it "assigns my_wiki to @wiki" do
        get :show, {id: my_wiki.id}
        expect(assigns(:wiki)).to eq(my_wiki)
      end
    end

    describe "DELETE destroy" do
     it "returns http redirect" do
       delete :destroy, {id: my_wiki.id}
       expect(response).to redirect_to(wiki_path)
     end
    end

  end

  context "standard user" do

    before do
      sign_in my_user
    end

    describe "GET Index" do
      it "assigns Wiki.all to Wiki" do
        get :index
        expect(assigns(:wikis)).to eq([my_wiki])
      end
    end
    describe "GET show" do
      it "renders the #show view" do
        get :show, {id: my_wiki.id}
        expect(response).to render_template :show
      end

      it "assigns my_wiki to @wiki" do
        get :show, {id: my_wiki.id}
        expect(assigns(:wiki)).to eq(my_wiki)
      end
    end

    describe "GET new" do
      it "renders the #new view" do
        get :new
        expect(response).to render_template :new
      end

      it "initializes @wiki" do
        get :new
        expect(assigns(:wiki)).not_to be_nil
      end
    end

    describe "POST create" do
      it "increases the number of wikis by 1" do
        expect{ post :create, wiki: {title: RandomData.random_sentence, body: RandomData.random_paragraph, private: false}, users: { id: [] } }.to change(Wiki,:count).by(1)
      end

      it "assigns Wiki.last to @wiki" do
        post :create, wiki: {title: RandomData.random_sentence, body: RandomData.random_paragraph, private: false}, users: { id: [] }
        expect(assigns(:wiki)).to eq Wiki.last
      end

      it "does not allow private wiki" do
        post :create, wiki: {title: RandomData.random_sentence, body: RandomData.random_paragraph, private: true}, users: { id: [] }
        created_wiki = assigns(:wiki)
        expect(created_wiki.private).to eq false
      end

      it "redirects to the new wiki" do
        post :create, wiki: {title: RandomData.random_sentence, body: RandomData.random_paragraph, private: false}, users: { id: [] }
        expect(response).to redirect_to Wiki.last
      end
    end

    describe "GET edit" do
      it "assigns wiki to be updated to @wiki" do
        get :edit, {id: my_wiki.id}
        wiki_instance = assigns(:wiki)

        expect(wiki_instance.id).to eq my_wiki.id
        expect(wiki_instance.title).to eq my_wiki.title
        expect(wiki_instance.body).to eq my_wiki.body
        expect(wiki_instance.private).to eq my_wiki.private
      end
    end

    describe "PUT update" do
      it "updates wiki with expected attributes and doesnt allow private" do
        new_title = RandomData.random_sentence
        new_body = RandomData.random_paragraph
        new_private = true

        put :update, id: my_wiki.id, wiki: {title: new_title, body: new_body, private: new_private}, users: { id: [] }, collabs: { id: [] }

        updated_wiki = assigns(:wiki)
        expect(updated_wiki.id).to eq my_wiki.id
        expect(updated_wiki.title).to eq new_title
        expect(updated_wiki.body).to eq new_body
        expect(updated_wiki.private).to eq false
      end

      it "redirects to the updated wiki" do
        new_title = RandomData.random_sentence
        new_body = RandomData.random_paragraph
        new_private = false

        put :update, id: my_wiki.id, wiki: {title: new_title, body: new_body, private: new_private}, users: { id: [] }, collabs: { id: [] }

        expect(response).to redirect_to my_wiki
      end
    end
  end

  context "premium user" do

    before do
      sign_in premium_user
    end

    describe "GET Index" do
      it "assigns Wiki.all to Wiki" do
        get :index
        expect(assigns(:wikis)).to eq([my_private_wiki])
      end
    end
    describe "GET show" do
      it "renders the #show view" do
        get :show, {id: my_private_wiki.id}
        expect(response).to render_template :show
      end

      it "assigns my_private_wiki to @wiki" do
        get :show, {id: my_private_wiki.id}
        expect(assigns(:wiki)).to eq(my_private_wiki)
      end
    end

    describe "GET new" do
      it "renders the #new view" do
        get :new
        expect(response).to render_template :new
      end

      it "initializes @wiki" do
        get :new
        expect(assigns(:wiki)).not_to be_nil
      end
    end

    describe "POST create" do
      it "increases the number of wikis by 1" do
        expect{ post :create, wiki: {title: RandomData.random_sentence, body: RandomData.random_paragraph, private: true}, users: { id: [other_user.id] } }.to change(Wiki,:count).by(1)
      end

      it "assigns Wiki.last to @wiki" do
        post :create, wiki: {title: RandomData.random_sentence, body: RandomData.random_paragraph, private: true}, users: { id: [other_user.id] }
        expect(assigns(:wiki)).to eq Wiki.last
      end

      it "allows private wiki" do
        post :create, wiki: {title: RandomData.random_sentence, body: RandomData.random_paragraph, private: true}, users: { id: [other_user.id] }
        created_wiki = assigns(:wiki)
        expect(created_wiki.private).to eq true
      end

      it "redirects to the new wiki" do
        post :create, wiki: {title: RandomData.random_sentence, body: RandomData.random_paragraph, private: true}, users: { id: [other_user.id] }
        expect(response).to redirect_to Wiki.last
      end
    end

    describe "GET edit" do
      it "assigns wiki to be updated to @wiki" do
        get :edit, {id: my_private_wiki.id}
        wiki_instance = assigns(:wiki)

        expect(wiki_instance.id).to eq my_private_wiki.id
        expect(wiki_instance.title).to eq my_private_wiki.title
        expect(wiki_instance.body).to eq my_private_wiki.body
        expect(wiki_instance.private).to eq my_private_wiki.private
      end
    end

    describe "PUT update" do
      it "updates wiki with expected attributes and removes collaborator" do
        new_title = RandomData.random_sentence
        new_body = RandomData.random_paragraph
        collab_id = my_collaborator.id

        put :update, id: my_private_wiki.id, wiki: {title: new_title, body: new_body}, users: { id: [] }, collabs: { id: [my_collaborator.id] }

        updated_wiki = assigns(:wiki)
        expect(updated_wiki.id).to eq my_private_wiki.id
        expect(updated_wiki.title).to eq new_title
        expect(updated_wiki.body).to eq new_body
        expect(updated_wiki.private).to eq true
        count = Collaborator.where({id: collab_id}).size
        expect(count).to eq 0
      end

    end
  end

end
