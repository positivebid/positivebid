class RootController < ApplicationController

  skip_before_filter :require_user


  layout 'app', :only => 'app'

  def index
    @logo_only = true
  end

  def about
    @logo_only = true
  end

  def frameset
    render :layout => 'frameset'
  end

  def frameset3
    render :layout => 'frameset'
  end

  def app
    respond_to do |format|
      format.json {
        set_r
        render :json => @r
      }
      format.html
    end
  end

  def justgiving_return
    Rails.logger.info "JUSTGIVING " + params.inspect

    if params[:donationId]
      # API lookup...
      response = HTTParty.get("https://#{JUSTGIVING_API_SERVER}/#{JUSTGIVING_APP_ID}/v1/donation/#{params[:donationId]}")

      Rails.logger.info response.body
      Rails.logger.info response.code
      Rails.logger.info response.message
      Rails.logger.info response.headers.inspect

      # Lot lookup...
      
      if our_ref = response.values[0]["thirdPartyReference"]
        if lot = Lot.find( our_ref.sub(/lot-/,'') )
          lot.cents_paid = (response.values[0]["amount"].to_f * 100 ).to_i
          lot.payment # transition
          lot.append_to_log("JUSTGIVING "+ params.inspect)
          lot.save!
        end
      end
    end
    redirect_to app_url
  end

  def minute
    Lot.minute_process
    render :text => "okay at #{Time.now.to_s}", :status => :ok
  end

  private

  def set_r 
    @r['current_user'] = current_user # == resource
    @r['auctions'] = ActiveModel::ArraySerializer.new(Auction.active.all(:include => :picture)).as_json
    @r['lots'] = Lot.visible.joins(:auction).where(:auctions => {:state => 'active'})
    @r['items'] = ActiveModel::ArraySerializer.new(Item.joins(:lot => [:auction]).where(:lots => {:state => Lot::VISIBLE_STATES}).where(:auctions => {:state => 'active'}).all(:include => :picture)).as_json
    @r['bids'] = Bid.joins(:lot => [:auction]).where(:lots => {:state => Lot::VISIBLE_STATES }).where(:auctions => {:state => 'active'})
    @r['users'] = ActiveModel::ArraySerializer.new(User.joins(:bids => [:lot => [:auction]]).where(:lots => {:state => Lot::VISIBLE_STATES }).where(:auctions => {:state => 'active'}).uniq.all).as_json
  end

end
