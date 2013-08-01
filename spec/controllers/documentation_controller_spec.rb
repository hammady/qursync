require 'spec_helper'

describe DocumentationController do

  describe "GET 'index'" do
    it "returns http success" do
      get 'index'
      response.should be_success
    end
  end

  describe "GET 'getting_started'" do
    it "returns http success" do
      get 'getting_started'
      response.should be_success
    end
  end

  describe "GET 'api_reference'" do
    it "returns http success" do
      get 'api_reference'
      response.should be_success
    end
  end

end
