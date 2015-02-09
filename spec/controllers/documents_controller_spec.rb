require 'rails_helper'

RSpec.describe DocumentsController, :type => :controller do
  describe 'GET new' do
    it 'is successful' do
      get :new, { :user_token => 'faketoken', :number_of_docs => '0' }
      expect(@response.status).to eq(200)
    end
  end

  describe 'POST /documents/USERTOKEN/DOCNUMBER/create' do
    let(:fake_redis) { double("Redis", :set => nil, :expire => nil) }
    let(:fake_verification_doc) { double("Calfresh::VerificationDoc", :original_file_path => '/tmp/fakepath') }

    before do
      allow(Redis).to receive(:new).and_return(fake_redis)
      allow(IO).to receive(:binread).and_return("fakebinaryimage")
      allow(Calfresh::VerificationDoc).to receive(:new).and_return(fake_verification_doc)
      post :create, { 'user_token' => 'fakeusertoken', 'doc_number' => '0', 'identification' => fixture_file_upload('files/spak with space.jpeg', 'image/jpeg') }
    end

    it 'instantiates a redis client' do
      expect(Redis).to have_received(:new)
    end

    it 'saves binary to redis' do
      expect(fake_redis).to have_received(:set).with("fakeusertoken_0_binary", "fakebinaryimage")
    end

    it 'expires the binary' do
      expect(fake_redis).to have_received(:expire).with("fakeusertoken_0_binary", 3600)
    end

    it 'saves filename to redis (removing spaces)' do
      expect(fake_redis).to have_received(:set).with("fakeusertoken_0_filename", "spakwithspace.jpeg")
    end

    it 'expires the filename' do
      expect(fake_redis).to have_received(:expire).with("fakeusertoken_0_filename", 3600)
    end

    it 'redirects with new number of docs' do
      expect(@response).to be_redirect
      expect(@response.location).to include('/documents/fakeusertoken/1')
    end
  end

  describe 'POST /documents/USERTOKEN/DOCNUMBER/submit' do
    let(:fake_redis) { double("Redis", :set => nil, :expire => nil) }
    let(:fake_sendgrid_client) { double("SendGrid::Client") }
    let(:fake_sendgrid_mail) { double("SendGrid::Mail") }
    let(:fake_file) { double("File") }

    before do
      allow(Redis).to receive(:new).and_return(fake_redis)
      allow(SendGrid::Client).to receive(:new).and_return(fake_sendgrid_client)
      allow(SendGrid::Mail).to receive(:new).and_return(fake_sendgrid_mail)
      # PENDING
      #post :submit, { 'user_token' => 'fakeusertoken', 'doc_number' => '1' }
    end

    context 'with two verification documents' do
      it 'instantiates a redis client' do
        pending
        expect(Redis).to have_received(:new)
      end

      # More tests
    end
  end
end