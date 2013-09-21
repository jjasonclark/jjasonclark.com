module Nesta
  class App
    helpers do
      # Add new helpers here.
    end

    def enable_comments?
      @page.flagged_as?('commented')
    end

    def send_email(subject, body)
        Pony.mail :via => 'smtp',
            :via_options => {
                :address => 'smtp.mandrillapp.com',
                :port => '587',
                :user_name => ENV['MANDRILL_USERNAME'],
                :password => ENV['MANDRILL_APIKEY'],
                :authentication => :plain,
                :domain => 'heroku.com'
            },
            :charset => 'utf-8',
            :to => 'jason@jjasonclark.com',
            :from => 'webform@jjasonclark.com',
            :subject => subject,
            :body => body
    rescue => e
        puts "Error while sending email. #{e.class}: #{e.message}"
    end

    # Add new routes here.
    require 'pony'
    post '/contact' do
        subject = "Web feedback: #{Rack::Utils.escape_html(params[:subject])}"
        body = Rack::Utils.escape_html(params[:body]) || 'No body'
        send_email subject, body
        redirect 'thank-you-for-feedback'
    end
  end
end
