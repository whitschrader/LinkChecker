require 'spec_helper'

describe "Sites" do
	describe "POST /sites" do 
		let(:data){ {site: {url: "example.com"}} }
		it 'adds and redirects after a format html post' do
			post '/sites', data
			response.code.should == "302"
			site = Site.where(:url => data[:site][:url]).first
			site.should_not be_nil
			response.should redirect_to site
		end

		it 'adds and redirects after a format json post' do
			post '/sites.json', data
			response.should be_success
			site = Site.where(:url => data[:site][:url]).first
			site.should_not be_nil
			JSON.parse(response.body)["id"].should == site.id
		end
	end

	describe "GET /sites/:id" do
		before do
			@site = Site.create!(:url => "no-links-here.com")
		end
		it 'gets an html page for an html GET' do
			get "/sites/#{@site.id}"
			response.should be_success
			response.body.should include(@site.url)
		end
		it 'gets JSON for a json GET' do
			get "/sites/#{@site.id}.json"
			response.should be_success
			JSON.parse(response.body).should include "url" => @site.url
		end
	end

	
end