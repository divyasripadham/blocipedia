require 'rails_helper'
include RandomData

RSpec.describe WikisController, type: :controller do
  include Devise::TestHelpers

  let(:my_user) { User.create!(email: 'testmember@example.com', password: 'helloworld', username: 'testmember') }
  let(:other_user) { User.create!(email: 'test2member@example.com', password: 'helloworld', username: 'test2member') }
  let(:my_wiki) { Wiki.create!(title: 'My Wiki', body: 'Wiki body', user: my_user) }

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
        expect{ post :create, wiki: {title: RandomData.random_sentence, body: RandomData.random_paragraph, user: my_user} }.to change(Wiki,:count).by(1)
      end

      it "assigns Wiki.last to @wiki" do
        post :create, wiki: {title: RandomData.random_sentence, body: RandomData.random_paragraph, user: my_user}
        expect(assigns(:wiki)).to eq Wiki.last
      end

      it "redirects to the new wiki" do
        post :create, wiki: {title: RandomData.random_sentence, body: RandomData.random_paragraph, user: my_user}
        expect(response).to redirect_to Wiki.last
      end
    end

    # describe "GET edit" do
    #  it "returns http redirect" do
    #    get :edit, {id: my_wiki.id}
    #    expect(response).to redirect_to(new_user_session_path)
    #  end
    # end
    #
    # describe "PUT update" do
    #  it "returns http redirect" do
    #    new_title = RandomData.random_sentence
    #    new_body = RandomData.random_paragraph
    #
    #    put :update, id: my_wiki.id, topic: {title: new_title, body: new_body }
    #    expect(response).to redirect_to(new_user_session_path)
    #  end
    # end

    # describe "DELETE destroy" do
    #  it "returns http redirect" do
    #    delete :destroy, {id: my_wiki.id}
    #    expect(response).to redirect_to(new_user_session_path)
    #  end
    # end
  end

end
