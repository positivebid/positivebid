# encoding: UTF-8
#
HELPS = [{
    "content" => "The PositiveBid web-application will display a photo representing your auction in order to help bidders select it. This photo can either be uploaded from a file on your computer using this input field, or by providing a URL in the next input field.",
        "key" => "auction[picture_attributes]_image_file",
      "title" => "<b>Auction Photo File</b>",
},{
    "content" => "The PositiveBid web-application will display a photo representing your auction in order to help bidders select it. This photo can either be uploaded by providing a URL in this input field, or from a file on your computer using the previous input field.",
        "key" => "auction[picture_attributes]_image_file_url",
      "title" => "<b>Auction Photo URL</b>",
},{
    "content" => "<p>The PositiveBid web-application is free for charities in England & Wales to use, but we do require confirmation from the charity benefiting from the funds raised that they approve of the auction.</p>\r\n<p>Please provide a charity contact name, email address and telephone number so that we can contact them and obtain this approval. If you are from the charity concerned you can provide your own details.</p>",
        "key" => "auction_charity_contact_email",
      "title" => "<b>Charity Contact Email</b>",
},{
    "content" => "<p>The PositiveBid web-application is free for charities in England & Wales to use, but we do require confirmation from the charity benefiting from the funds raised that they approve of the auction.</p>\r\n<p>Please provide a charity contact name, email address and telephone number so that we can contact them and obtain this approval. If you are from the charity concerned you can provide your own details.</p>",
        "key" => "auction_charity_contact_name",
      "title" => "<b>Charity Contact Name</b>",
},{
    "content" => "<p>The PositiveBid web-application is free for charities in England & Wales to use, but we do require confirmation from the charity benefiting from the funds raised that they approve of the auction.</p>\r\n<p>Please provide a charity contact name, email address and telephone number so that we can contact them and obtain this approval. If you are from the charity concerned you can provide your own details.</p>",
        "key" => "auction_charity_contact_telephone",
      "title" => "<b>Charity Contact Telephone No.</b>",
},{
    "content" => "Enter the name of the charity that will be benefiting from the funds raised at the auction.",
        "key" => "auction_charity_name",
      "title" => "<b>Charity Name</b>",
},{
    "content" => "<p>The bidding on Lots can be scheduled to open and close automatically, or can be opened and closed manually by the auction organiser. Select which procedure you wish to use for the auction.</p>\r\n<p>Where the automatic opening / closing option is selected the default times entered below will be used. It is possible to alter these default times when inputting individual Lot details.</p>",
        "key" => "auction_default_lot_timing",
      "title" => "<b>Default Bidding Times for Lots</b>",
},{
    "content" => "Where bidding on Lots will be closing automatically, the default time entered here will be used. ",
        "key" => "auction_default_sale_end_at",
      "title" => "<b>Default Bidding End Time</b>",
},{
    "content" => "Where bidding on Lots will be opening automatically, the default time entered here will be used. ",
        "key" => "auction_default_sale_start_at",
      "title" => "<b>Default Bidding Start Time</b>",
},{
    "content" => "<p>This description will be presented to bidders using the PositiveBid web-application, enabling them to select the correct auction for the charity event they are supporting.</p>\r\n<p>We suggest you keep the description short with factual information about the auction.</p>",
        "key" => "auction_description",
      "title" => "<b>Auction Description</b>",
},{
    "content" => "Enter the time and date at which the event, where the charity auction is occurring, ends using the input fields provided when you click in the input field.",
        "key" => "auction_event_end_at",
      "title" => "<b>Charity Event End Time</b>",
},{
    "content" => "Enter the time and date at which the event, where the charity auction is occurring, starts using the input fields provided when you click in the input field.",
        "key" => "auction_event_start_at",
      "title" => "<b>Charity Event Start Time</b>",
},{
    "content" => "<p>The winning bidder for a Lot can either pay online through Just Giving, or manually with the auction organisers. Please select at least one of these methods for the winning bidder to use.</p>\r\n<p>With the Just Giving option you will need to provide a JustGiving SDI Charity Id in the input field that appears.</p>\r\n",
        "key" => "auction_justgiving_payment_accepted",
      "title" => "<b>Just Giving Payment Acceptance</b>",
},{
    "content" => "<p>Please enter the benefiting charity's JustGiving SDI Charity Id here so that we can direct payments from the winning bidders to the correct account.</p>\r\n<p>PositiveBid does not directly handle the online payment for Lots from winning bidders.</p>",
        "key" => "auction_justgiving_sdi_charity_id",
      "title" => "<b>JustGiving SDI Charity Id</b>",
},{
    "content" => "The address of the charity event where the auction is taking place should be entered here. If there is no location it can be left blank.",
        "key" => "auction_location",
      "title" => "<b>Auction Location<b>",
},{
    "content" => "The winning bidder for a Lot can either pay manually, or online through Just Giving. Please select at least one of these methods for the winning bidder to use.",
        "key" => "auction_manual_payment_accepted",
      "title" => "<b>Manual Payment Acceptance</b>",
},{
    "content" => "Please instruct winning bidders how that should make a manual payment for the Lot they have won. These instructions will be displayed by the PositiveBid web-application to the winning bidder on their screen.",
        "key" => "auction_manual_payment_instructions",
      "title" => "<b>Manual Payment Instructions</b>",
},{
    "content" => "<p>Auction names will be presented to bidders using the PositiveBid web-application, enabling them to select the correct auction for the charity event they are supporting.</p>\r\n<p>The auction name should be kept to under 20 characters if possible.</p>",
        "key" => "auction_name",
      "title" => "<b>Auction Name</b>",
},{
    "content" => "Please give us your email address so that we contact you.",
        "key" => "auction_organiser_email",
      "title" => "Organiser Email Address",
},{
    "content" => "Please enter the name of the Auction Organiser (ie. Your Name!)",
        "key" => "auction_organiser_name",
      "title" => "Organiser Name",
},{
    "content" => "Please give us your telephone number so that we contact you by telephone (only when if need be).",
        "key" => "auction_organiser_telephone",
      "title" => "Organiser Telephone Number",
},{
    "content" => "<p>When an auction is organised it is first created in a \"draft\" state which is not available for the public to view.</p>\r\n<p>Once the organiser has created the auction they can submit it for approval by PositiveBid using the \"Organiser submit\" button provided. The auction first enters a \"submitted\" state, and then an \"active\" state once it has been approved by PositiveBid. When active it becomes available for the public to view.</p>\r\n<p>Finally, when the auction has closed the organiser can archive the auction, which will remove it from public display in the web-application. The auction <b>state</b> can be seen towards the bottom of the table below.</p>",
        "key" => "auction_show_links",
      "title" => "<b>Auction Status</b>",
},{
    "content" => "Auctions occurring in England or Wales before spring 2013 should use this default setting.",
        "key" => "auction_time_zone",
      "title" => "<b>Time Zone</b>",
},{
    "content" => "The PositiveBid web-application can display a photo of the item. This photo can either be uploaded from a file on your computer using this input field, or by providing a URL in the next input field.",
        "key" => "item[picture_attributes]_image_file",
      "title" => "<b>Item Photo File</b>",
},{
    "content" => "The PositiveBid web-application can display a photo of the item. This photo can either be uploaded by providing a URL in this input field, or from a file on your computer using the previous input field.",
        "key" => "item[picture_attributes]_image_file_url",
      "title" => "<b>Item Photo URL</b>",
},{
    "content" => "This optional field is for any collection information that relates to the item in the Lot.",
        "key" => "item_collection_info",
      "title" => "<b>Item Collection Information</b>",
},{
    "content" => "<p>The description of each item in a Lot will be displayed to bidders in the web-application when they click on the item name. The description should provide enough information for users to decide whether or not to bid on the Lot.</p>\r\n<p>Any item Terms & Conditions, or Collection Information, will be provided separately from the description.</p>",
        "key" => "item_description",
      "title" => "<b>Item Description</b>",
},{
    "content" => "A byline provided by the donor of the item will be displayed in the application. It is optional.",
        "key" => "item_donor_byline",
      "title" => "<b>Donor Byline</b>",
},{
    "content" => "The name of the item donor will be displayed in the application. It is optional.",
        "key" => "item_donor_name",
      "title" => "<b>Donor Name</b>",
},{
    "content" => "The url of the donor website will be used to provide a link to their website from the donated item information in the application. It is optional.",
        "key" => "item_donor_website_url",
      "title" => "<b>Donor Website</b>",
},{
    "content" => "The name of each item in a Lot will be displayed to bidders in the web-application. We suggest you keep this name as short as possible.",
        "key" => "item_name",
      "title" => "<b>Item Name</b>",
},{
    "content" => "<p>This field is for internal use by the auction organiser, and will not be displayed to users of the web-application.</p>\r\n<p>It is provided to help organisers manage the items in the Lots, as well as the auction generally, by recording any necessary notes.</p>",
        "key" => "item_organiser_notes",
      "title" => "<b>Organiser Notes</b>",
},{
    "content" => "This optional field is for any particular Terms and Conditions that apply to the item in the Lot.",
        "key" => "item_terms",
      "title" => "<b>Item Terms & Conditions</b>",
},{
    "content" => "<p>The bidding for Lots will increase in increments of this size.</p>\r\n<p>We suggest this figure is approximately 5% of the Lot's estimated value.</p>",
        "key" => "lot_min_increment",
      "title" => "<b>Bidding Increment</b>",
},{
    "content" => "The Lot name will be displayed to bidders using the PositiveBid web-application. Try to restrict this to 20 characters if possible.",
        "key" => "lot_name",
      "title" => "<b>Lot Name</b>",
},{
    "content" => "<p>Enter a Lot number which will determine where the Lot is displayed in the auction catalog.</p>\r\n<p>This number needs to be unique so do not use a number that has been used before.</p>",
        "key" => "lot_number",
      "title" => "<b>Lot Number</b>",
},{
    "content" => "Where bidding on a Lot is scheduled to end automatically the default time entered here will be used to end the bidding. ",
        "key" => "lot_sale_end_at",
      "title" => "<b>Lot Bidding End Time</b>",
},{
    "content" => "Where bidding on a Lot is scheduled to open automatically the default time entered here will be used to open the bidding. ",
        "key" => "lot_sale_start_at",
      "title" => "<b>Lot Bidding Start Time</b>",
},{
    "content" => "<p>When a Lot is first created it is in a \"draft\" state which is not open for the public to view. An \"Organiser publish\" button enables the Lot to be published making it publicly viewable.</p>\r\n<p>Bidding on a Lot will either open automatically at the scheduled time, or by the organiser manually opening bidding with the button provided. Manual opening will over-ride automatic scheduled opening. Two buttons then allow manual closing on a Lot by either initiating a closing procedure which allows further bidding on the Lot for a limited period of time, or by closing the bidding on a Lot immediately.</p>\r\n<p>Finally, a button enables the organiser to mark the Lot as having been paid for, when the winning bidder has made a manual payment.</p>",
        "key" => "lot_show_links",
      "title" => "<b>Lot Status</b>",
},{
    "content" => "<p>The bidding on Lots can be scheduled to open and close automatically, or can be opened and closed manually by the auction organiser. Select which procedure you wish to use for this Lot.</p>\r\n<p>Where the scheduled opening / closing option is selected the times entered below will be used by the application to open and close the bidding. With scheduled opening / closing it is always possible for the auction organiser to manually open and close the bidding on a Lot using the buttons shown to the organiser on the Lot page.</p>",
        "key" => "lot_timing",
      "title" => "<b>Lot Bidding Times</b>",
}]
