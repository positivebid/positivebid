class BiddingController < ApplicationController


  def create 

    unless current_user
      return :json => {:message => "please log in"}
    end

    bid = Bid.new(params[:bidding])
    bid.user = current_user

    if bid.save
      render :json => bid
    else
      render :json => {:errors => bid.errors }
    end

  end

end
