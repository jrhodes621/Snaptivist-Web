# this is a publicly available API. As yet there is no authentication.
require 'nation_builder_web_hook.rb'
require 'jobs/nationbuilder.rb'

class API < Grape::API
  version 'v1', using: :header, vendor: "Snaptivist"
  format :json
  formatter :json, Grape::Formatter::Rabl

  helpers do
    def current_account
      elements = request.env["HTTP_HOST"].split(":").first.split(".")
      if elements.count == 3
        Account.where(:subdomain => /#{elements.first}/i).first
      else
        error!('404 Not Found', 404)
      end
    end
  end

  resource :clients do

    desc "Return all petitions for the specified client."
    get "/:id/petitions", :rabl => "petitions" do
      client = Client.find(params[:id])
      @petitions = Petition.where(:client_id => client.id)
        .order("created_at desc")             
    end

    desc "Create a new petition for the specified client"
    post "/:id/petitions", :rabl => "petition" do

      client = Client.find(params[:id])
      layout = Layout.first
      theme = layout.themes.first

      #binding.pry

      @petition = Petition.create({
          title: params[:title],
          subdomain: params[:subdomain],
          layout: layout,
          theme: theme
        })

      #REDIS.set("action-" + @petition.id, params[:content])

    end

    desc "Updates a petition for the specified client"
    put "/:client_id/petitions/:id", :rabl => "petition" do

      client = Client.find(params[:client_id])
      @petition = Petition.find(params[:id])
    
      #TODO: This is kind of a hack


      REDIS.set("action-" + @petition.id.to_s, params[:content])

    end

	desc "Saves Nation Builder OAuth Credentials for the specified client"
    post "/:client_id/nation_builder_oauth_credentials" do

      session = env['rack.session']

      client = Client.find(params[:client_id])

      session['nation_name'] = params[:nation_name]
      session['client_app_id'] = params[:client_uid]
      session['client_secret'] = params[:client_secret]
      session['redirect_uri'] = params[:redirect_uri]

    end

    # desc "crm webhook to add or update a user"
    # post "/:client_id/webhooks/user" do
    #   Resque.enqueue(Nationbuilder, params[:client_id], params[:payload])
    # end

    desc "crm webhook to add or update a donation"
    post "/:client_id/webhooks/donation" do
      client = Client.find(params[:client_id], client)
      
      webhook = CrmWebHook::NationBuilderCrmWebHook.new
      webhook.create_or_update_donation(params[:payload])

    end


    desc "get supporters for a client"
    get "/:client_id/supporters", :rabl => "supporters" do

      page_size = 10
      offset = 0

      if params[:offset]
        offset = params[:offset]
      end

      client = Client.find(params[:client_id])
      order_column = "last_name"
      @supporters = client.supporters.order(order_column).limit(page_size).offset(offset)
      @total = client.supporters.count
    end

  end

  resource :layouts do

    desc "Return all layouts."
    get "/", :rabl => "layouts" do
      @layouts = Layout.all
                        
    end

  end

  resource :email_types do

    desc "Return all email types."
    get "/", :rabl => "email_types" do
      @email_types = EmailType.order("position asc")
        .all
                        
    end

  end    

  resource :conditional_action_tag_types do

    desc "Return all conditional action tag types."
    get "/", :rabl => "conditional_action_tag_types" do
      @conditional_action_tag_types = ConditionalActionTagType.all
                        
    end

  end    


  resource :pages do

    desc "Return all pages for a give layout."
    get "/", :rabl => "pages" do
      layout = Layout.find(params[:layout_id])
      @pages = layout.pages.order("position asc")           
    end

  end    

  resource :petitions do

    desc "Return all petitions."
    get "/", :rabl => "petitions" do
      @petitions = Petition.all
                        
    end

    desc "Return the specified petition."
    get "/:id", :rabl => "petition" do
      @petition = Petition.find(params[:id])   
      @content =  JSON.parse(REDIS.get("action-" + @petition.id.to_s))
     
    end

    desc "get signatures for a petition"
    get "/:id/signatures", :rabl => "signatures" do

      page_size = 10
      offset = 0

      if params[:offset]
        offset = params[:offset]
      end

      @petition = Petition.find(params[:id])   
     
      @signatures = @petition.signatures.limit(page_size).offset(offset)
      @total = @petition.signatures.count
    end

    desc "get shares for a petition"
    get "/:id/shares", :rabl => "shares" do

      page_size = 10
      offset = 0

      if params[:offset]
        offset = params[:offset]
      end

      @petition = Petition.find(params[:id])   
     
      @shares = @petition.signatures.where(:shared => true).limit(page_size).offset(offset)
      @total = @petition.signatures.where(:shared => true).count
    end

    desc "get tweet for a petition"
    get "/:id/tweets", :rabl => "tweets" do

      page_size = 10
      offset = 0

      if params[:offset]
        offset = params[:offset]
      end

      @petition = Petition.find(params[:id])   
     
      @signatures = @petition.signatures.where(:delivered => true).limit(page_size).offset(offset)
      @total = @petition.signatures.where(:delivered => true).count
    end

    desc "get premium redemptions for a petition"
    get "/:id/premiums", :rabl => "premiums" do

      page_size = 10
      offset = 0

      if params[:offset]
        offset = params[:offset]
      end

      @petition = Petition.find(params[:id])   
     
      @premiums = @petition.premium_redemptions.limit(page_size).offset(offset)
      @total = @petition.premium_redemptions.count
    end

  end

  resource :themes do

    desc "Return all themes."
    get "/", :rabl => "themes" do
      @themes = Layout.find(params[:layout_id]).themes
                        
    end

  end


end