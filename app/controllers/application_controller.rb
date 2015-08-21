class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  APP_ID = '1058776843287992991'
  AFF_ID = '0ed09397.f1118ed0.0ed09398.e11f5358'
  private
    RakutenWebService.configuration do |c|
      c.application_id = APP_ID
      c.affiliate_id = AFF_ID
    end
end
