class App < Sinatra::Application

  enable :sessions

  get '/' do
    redirect '/mail-merge'
  end

  get '/mail-merge' do
    erb :mail_merge
  end

  post '/verify-mandrill' do
    session[:key] = params[:key]
    mandrill = Mandrill.new(session[:key])

    if mandrill.can_connect?
      message = "Connection successful: User is #{mandrill.username}"
    else
      message = I18n.t :mandrill_cannot_connect
    end

    {:can_connect => mandrill.can_connect?, :message => message}.to_json
  end

  post '/select-template' do
    session[:template] = params[:template]
    {:success => true, :message => session[:template]}.to_json
  end

  post '/send-test' do
    return {:can_connect => false, :message => I18n.t(:enter_key), :goto_section => 'connect_mandrill'}.to_json unless session[:key]
    return {:can_connect => false, :message => I18n.t(:select_template), :goto_section => 'select_template'}.to_json unless session[:template]
    return {:success => false, :message => I18n.t(:enter_email)}.to_json unless valid_email?(params[:email])
    mandrill = Mandrill.new(session[:key])
    return {:can_connect => false, :message => I18n.t(:mandrill_cannot_connect), :goto_section => 'connect_mandrill'}.to_json unless mandrill.can_connect?
    {:can_connect => true, :success => true, :message => I18n.t(:test_sent)}.to_json
  end

  get '/docs' do
    erb :index
  end

end