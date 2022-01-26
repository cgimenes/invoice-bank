require 'rails_helper'

RSpec.describe "Imports", type: :request do
  describe "Toptal payment" do
    let(:paid_file) { fixture_file_upload 'toptal_paid.pdf', 'application/pdf' }

    it "(paid)" do
      post "/import/import", params: { file: paid_file }

      expect(response.content_type).to eq("application/json; charset=utf-8")
      expect(response).to have_http_status(:created)
    end
  end

  describe "transfer PDF" do
    let(:file) { fixture_file_upload 'transfer.pdf', 'application/pdf' }

    it "" do
      post "/import/import", params: { file: file }

      expect(response.content_type).to eq("application/json; charset=utf-8")
      expect(response).to have_http_status(:created)
    end
  end
end
