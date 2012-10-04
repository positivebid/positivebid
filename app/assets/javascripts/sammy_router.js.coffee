PB = window.PB ||= {}

PB.app = $.sammy(->
  
  reverse_back = false  # here for closure scope 

  useReverse = ->
    if window.reverse_back
      window.reverse_back = false
      true
    else
      false

  # remove the last page.
  #$('div').live 'pageshow', (event, ui) ->
  #  ui.prevPage.remove()

  render = (sv) ->
    #window.sv = sv
    $v = sv.html
    PB.$body.append $v
    $v.page()  # jquery mobile enhance
    $oldv = $.mobile.activePage
    $.mobile.changePage $v
    $oldv?.remove()
    #if  sv.cid != @oldsview?.cid
    @oldsview?.destroy()
    @oldsview = sv

  sammy_hack = (context) ->
    window.setTimeout (->
      location_proxy.unbind()
      context.app.setLocation "#/"
      context.app.last_location = "#/"
      location_proxy.bind()
    ), 55 # so that the same path can be called twice, eg '#/more'

  @element_selector = "body"
  #location_proxy = new Sammy.DataLocationProxy(this, "location", "sam_click")
  #@setLocationProxy location_proxy
  @use Sammy.NestedParams
  @hist = []
  reverse_back = false
  form_auction = null  # set scope

  #@get "#/workplaces/:id/employees", (context) ->
  #  app.hist.push context.path
  #  render tc["workplace_employees_jlt"].jlt(Workplace.find(context.params.id))
  #  false
  
  @get "#/", (context) ->
    context.redirect("#/auctions")

  @get "#/login",  (context) ->
    render( new Sview('login', {}) )
  
  @get "#/auctions",  (context) ->
    render( new Sview('auctions_index', {auctions: PB.auctions}) )

  @post "#/auctions",  (context) ->
    new_auction = new PB.Auction(context.params.auction)
    new_auction.save()
    context.redirect("#/auctions")
    return false
  
  @get "#/auctions/new", (context) ->
    form_auction = new PB.Auction()
    render( new Sview('auctions_new', {auction: form_auction }) )

  @get "#/auctions/:id", (context) ->
    #OLD window.socket.emit 'enter_auction', { id: context.params.id }
    render( new Sview('auctions_show', {auction: PB.auctions.get(context.params.id)}) )
    
  @get "#/auctions/:auction_id/lots", (context) ->
    auction = PB.auctions.get(context.params.auction_id)
    unless auction?
      console?.log 'auction not found for id:', context.params.auction_id
      context.redirect("#/")
      return false
    render( new Sview('lots_index', {auction: auction, lots: PB.lots}) )

  @post "#/lots",  (context) ->
    new_lot = new PB.Lot(context.params.lot)
    new_lot.save()
    context.redirect("#/auctions/#{new_lot.auction_id}/lots")
    return false

  @get "#/auctions/:auction_id/lots/new", (context) ->
    auction = PB.auctions.get(context.params.auction_id)
    unless auction?
      console?.log 'auction not found for id:', context.params.auction_id
      context.redirect("#/")
      return false
    render( new Sview('lots_new', {auction: auction, lot: new PB.Lot(auction_id: auction.id) }) )

  @get "#/lots/:id", (context) ->
    lot = PB.lots.get(context.params.id)
    unless lot?
      console?.log 'lot not found for id:', context.params.id
      context.redirect("#/")
      return false
    render( new Sview('lots_show', {lot: lot, auction: lot.auction(), items: lot.items }) )

  @post "#/items",  (context) ->
    new_item = new PB.Item(context.params.item)
    new_item.save()
    context.redirect("#/lots/#{new_item.lot_id}")
    return false

  @get "#/lots/:lot_id/items/new", (context) ->
    lot = PB.lots.get(context.params.lot_id)
    unless lot?
      console?.log 'lot not found for id:', context.params.lot_id
      context.redirect("#/")
      return false
    render( new Sview('items_new', {lot: lot, item: new PB.Item(lot_id: lot.id) }) )
 
  @get "#/items/:id", (context) ->
    item = PB.items.get(context.params.id)
    unless item?
      console?.log 'item not found for id:', context.params.id
      context.redirect("#/")
      return false
    render( new Sview('items_show', {item: item, lot: item.lot() }) )

  @post "#/bids",  (context) ->
    new_bid = PB.bids.create(context.params.bid)
    context.redirect("#/lots/#{new_bid.lot_id}")
    return false

  @get "#/reload", (context) ->
    console.log 'here1'
    render( new Sview('reload', {}) )
    console.log 'here2'
    window.reverse_back = true
    console.log 'here3'
    setTimeout ->
      reloadR( ->
        console.log 'here4'
        context.redirect "#/auctions"
      , ->
        removeExistingModelData()
        delete R.current_user
        context.redirect "#/root"
        gritter
          title: "Data Error"
          text: "logging you out!"
      )
      

    , 500  # need to wait for jquery mobile page to fully render
    false

#  @post "#/users", (context) ->
#    u = new User(context.params.user)
#    localStorage_setItem("email", context.params.user?.email) if supports_html5_storage()
#    u.save (success) ->
#      if success
#        context.redirect "#/root"
#        gritter
#          title: "Account Created!"
#          text: "Please check your email for an activation link"
#          time: 10000
#      else
#        render tc["users_new"].jlt(u)
#    false
#
#  @get "#/login", (context) ->
#    email = ""
#    email = localStorage_getItem("email") if supports_html5_storage()
#    render tc["login"].jlt(email: email)
#    false
#
#  @post "#/login", (context) ->
#    surl = R.app_host + "/user_sessions.json"
#    localStorage_setItem("email", context.params.user_session.email) if supports_html5_storage()
#    $.ajax
#      dataType: "json"
#      type: "POST"
#      url: surl
#      contentType: "application/json"
#      data: JSON.stringify(user_session: context.params.user_session)
#      complete: (xhr, textStatus) ->
#        data = if /\S/.test(xhr.responseText) then jQuery.parseJSON(xhr.responseText) else undefined
#        if textStatus == "success"
#          if data.success
#            $("meta[name=csrf-token]").remove()
#            $("head").append $("<meta/>",
#              name: "csrf-token"
#              content: data.token
#            )
#            context.redirect "#/reload"
#          else
#            render tc["login"].jlt
#              email: context.params.user_session.email
#              errors: data.error || data.message
#            gritter
#              title: 'Error'
#              text: data.error || data.message
#        else
#          if data.message
#            errmsg = data.message
#          else
#            errmsg = "login error!<br/>username or password incorrect?"
#          render tc["login"].jlt
#            email: context.params.user_session.email
#            errors: errmsg
#          gritter
#            title: 'Login Error'
#            text: 'login error'
#    false
#
#  @get "#/reload", (context) ->
#    render tc["reload"].jlt()
#    window.reverse_back = true
#    setTimeout ->
#      reloadR( ->
#        context.redirect "#/home"
#      , ->
#        removeExistingModelData()
#        delete R.current_user
#        context.redirect "#/root"
#        gritter
#          title: "Data Error"
#          text: "logging you out!"
#      )
#
#    , 500  # need to wait for jquery mobile page to fully render
#    false
#
#        
#  @get '#/home/picture/edit', (context) ->
#    render tc["picture_edit"].jlt()
#    false
#
#  @put '#/home/picture', (context) ->
#    data = new FormData($(@target)[0])
#    # Options to tell JQuery not to process data or worry about content-type
#    ajaxopts =
#      cache: false
#      contentType: false
#      processData: false
#    if csrf_param()? and csrf_token()?
#      data.append(csrf_param(), csrf_token())
#    a = $.ajax($.extend({}, ajaxopts,
#      type: "PUT"
#      url: "#{R.app_host}/home/picture"
#      data: data
#      xhr: -> # custom xhr
#        myXhr = $.ajaxSettings.xhr()
#        if (myXhr.upload) # check if upload property exists
#          myXhr.upload.addEventListener('progress',progressHandlingFunction, false)  # for handling the progress of the upload
#        return myXhr
#      success: (data) ->
#        current_user.merge
#          picture_id: data.id
#        current_user.trigger "update"
#        context.redirect "#/profile"
#        gritter
#          title: "Success!"
#          text: "Profile Picture updated."
#      error: (xhr, code, reason) ->
#        alert "upload error - please supply a valid image"
#    ))
#    false
#
#
#  @get '#/home/edit', (context) ->
#    render tc["home_edit"].jlt(current_user)
#    false
#
#  @put '#/home', (context) ->
#    current_user.attr context.params.user
#    current_user.save (success) ->
#      if success
#        context.redirect "#/profile"
#        gritter
#          title: "Profile Updated"
#          text: "Your profile has been updated."
#      else
#        render tc["home_edit"].jlt(current_user)
#    false
#
#  @get '#/home/photos', (context) ->
#    render tc["photos"].jlt({photos: current_user.photos().all()})
#    false
#
#  @get '#/home/photos/new', (context) ->
#    render tc["photos_new"].jlt()
#    false
#
#  @post '#/home/photos', (context) ->
#    p = new Photo(context.params.photo)
#    p.attr('owner_type', 'User')
#    data = new FormData($(@target)[0])
#    if csrf_param()? and csrf_token()?
#      data.append(csrf_param(), csrf_token())
#    # Options to tell JQuery not to process data or worry about content-type
#    ajaxopts =
#      cache: false
#      contentType: false
#      processData: false
#
#    a = $.ajax($.extend({}, ajaxopts,
#      type: "POST"
#      url: "#{R.app_host}/home/photos"
#      data: data
#      xhr: -> # custom xhr
#        myXhr = $.ajaxSettings.xhr()
#        if (myXhr.upload) # check if upload property exists
#          myXhr.upload.addEventListener('progress',progressHandlingFunction, false)  # for handling the progress of the upload
#        return myXhr
#      success: (data) ->
#        p.merge data
#        p.trigger "update"
#        Photo.add(p)
#        context.redirect "#/home/photos"
#        gritter
#          title: "Success!"
#          text: "Photo posted."
#      error: (xhr, code, reason) ->
#        alert "upload error - please supply a valid image"
#    ))
#
#    false
#        
#
#  @del '#/photos/:id', (context) ->
#    #TODO
#    render tc["photos_new"].jlt(current_user)
#    false
#
#  @get '#/company', (context) ->
#    render tc["company"].jlt(current_user.company())
#    false
#
#  @get '#/company/edit', (context) ->
#    render tc["company_edit"].jlt(current_user.company())
#    false
#
#  @put '#/company', (context) ->
#    company = current_user.company()
#    company.attr context.params.company
#    company.save (success) ->
#      if success
#        context.redirect "#/company"
#        gritter
#          title: "Company Updated"
#          text: "Your company has been updated."
#      else
#        render tc["company_edit"].jlt(company)
#    false
#
#  @get '#/company/picture/edit', (context) ->
#    render tc["company_picture_edit"].jlt(current_user.company())
#    false
#
#  @put '#/company/picture', (context) ->
#    data = new FormData($(@target)[0])
#    # Options to tell JQuery not to process data or worry about content-type
#    ajaxopts =
#      cache: false
#      contentType: false
#      processData: false
#    if csrf_param()? and csrf_token()?
#      data.append(csrf_param(), csrf_token())
#    a = $.ajax($.extend({}, ajaxopts,
#      type: "PUT"
#      url: "#{R.app_host}/home/company_administrator/picture"
#      data: data
#      xhr: -> # custom xhr
#        myXhr = $.ajaxSettings.xhr()
#        if (myXhr.upload) # check if upload property exists
#          myXhr.upload.addEventListener('progress',progressHandlingFunction, false)  # for handling the progress of the upload
#        return myXhr
#      success: (data) ->
#        current_user.company().merge
#          picture_id: data.id
#        current_user.company().trigger "update"
#        context.redirect "#/company"
#        gritter
#          title: "Success!"
#          text: "Logo updated."
#      error: (xhr, code, reason) ->
#        alert "upload error - please supply a valid image"
#    ))
#    false
#
#  @get '#/domains', (context) ->
#    render tc["domains"].jlt(current_user.company())
#    false
#
#  @get '#/domains/new', (context) ->
#    render tc["domains_new"].jlt({})
#    false
#
#  @post '#/domains', (context) ->
#    d = new Domain(context.params.domain)
#    d.save (success) ->
#      if success
#        context.redirect "#/domains"
#        gritter
#          title: "Domain Created"
#          text: "New domain has been added to your company."
#      else
#        render tc["domains_new"].jlt(d)
#    false
#
#  @get '#/domains/:id', (context) ->
#    d = Domain.find context.params.id
#    render tc["domains_delete"].jlt(d)
#    false
#
#  @del '#/domains/:id', (context) ->
#    d = Domain.find context.params.id
#    d.destroy (success) ->
#      if success
#        context.redirect "#/domains"
#        gritter
#          title: "Domain Deleted!"
#          text: d.domain() + " has been deleted."
#      else
#        context.redirect "#/domains"
#        # todo, get error message.
#        gritterError("oh oh, couldn't delete domain")
#    false
#
#  @get '#/colleagues', (context) ->
#    render tc["colleagues"].jlt(current_user.company())
#    false
#
#  @get '#/colleagues/:id', (context) ->
#    c = User.find context.params.id
#    render tc["colleague"].jlt(c)
#    false
#
#  @post '#/followings', (context) ->
#    f = new Following(context.params.following)
#    f.save (success) ->
#      if success
#        context.redirect "#/colleagues/#{f.leader_id()}"
#        gritter
#          title: "Followed!"
#          text: "You're now following #{f.leader().name()}."
#      else
#        context.redirect "#/colleagues/#{f.leader_id()}"
#        gritterError "Oh oh! Something went wrong"
#    false
#
#  @del '#/followings/:id', (context) ->  # leader_id (not following id)
#    f = User.find(context.params.id)?.cu_following()
#    f.destroy (success) ->
#      if success
#        context.redirect "#/colleagues/#{f.leader_id()}"
#        gritter
#          title: "Unfollowed!"
#          text: "You are not following #{f.leader().name()}."
#      else
#        context.redirect "#/colleagues/#{f.leader_id()}"
#        # todo, get error message.
#        gritterError("oh oh, couldn't unfollow")
#    false
#
# 
#  colleague_method = (user_id, method, context) ->
#    data = {}
#    data[csrf_param()] = csrf_token()  if csrf_param()? and csrf_token()?
#    user = User.find user_id
#    a = $.ajax
#      type: "PUT"
#      dataType: 'json'
#      contentType: "application/json"
#      url: "#{R.app_host}/home/company_administrator/colleagues/#{user.id()}/#{method}"
#      data: JSON.stringify(data)
#      success: (data) ->
#        user.merge data
#        user.trigger "update"
#        context.redirect "#/colleagues/#{user.id()}"
#        gritter
#          title: "Success!"
#          text: "Colleague updated."
#      error: (xhr, code, reason) ->
#        gritterError "Oh oh. An error occured."
#    false
#
#
#  @put '#/grant/:id', (context) ->
#    colleague_method(context.params.id, 'grant', context)
#
#  @put '#/revoke/:id', (context) ->
#    colleague_method(context.params.id, 'revoke', context)
#
#  @put '#/grant_deals/:id', (context) ->
#    colleague_method(context.params.id, 'grant_deals', context)
#
#  @put '#/revoke_deals/:id', (context) ->
#    colleague_method(context.params.id, 'revoke_deals', context)
#
#  @get '#/locations', (context) ->
#    render tc["locations"].jlt(current_user.company())
#    false
#
#  @get '#/locations/new', (context) ->
#    render tc["locations_new"].jlt new Location()
#    false
#
#  @post '#/locations', (context) ->
#    l = new Location(context.params.location)
#    l.save (success) ->
#      if success
#        context.redirect "#/locations/#{l.id()}"
#        gritter
#          title: "Location Created"
#          text: "New location has been added to your company."
#      else
#        render tc["locations_new"].jlt(l)
#    false
#
#  @get '#/locations/:id', (context) ->
#    l = Location.find context.params.id
#    render tc["location"].jlt(l)
#    false
#
#  @get '#/locations/:id/edit', (context) ->
#    l = Location.find context.params.id
#    render tc["locations_new"].jlt(l)
#    false
#
#  @put '#/locations/:id', (context) ->
#    l = Location.find context.params.id
#    l.attr context.params.location
#    l.save (success) ->
#      if success
#        context.redirect "#/locations/#{l.id()}"
#        gritter
#          title: "Location Updated"
#          text: "#{l.name()} has been updated."
#      else
#        render tc["locations_new"].jlt(l)
#    false
#
#  @get '#/locations/:id/delete', (context) ->
#    l = Location.find context.params.id
#    render tc["locations_delete"].jlt(l)
#    false
#
#  @del '#/locations/:id', (context) ->
#    l = Location.find context.params.id
#    l.destroy (success) ->
#      if success
#        context.redirect "#/locations"
#        gritter
#          title: "Location Deleted!"
#          text: "#{l.name()} has been deleted."
#      else
#        context.redirect "#/locations"
#        # todo, get error message.
#        gritterError("oh oh, couldn't delete location")
#    false
#
#  @get '#/deals_administrator', (context) ->
#    render tc["deals_administrator"].jlt(current_user.company())
#    false
#
#  @get '#/deals_administrator/photos', (context) ->
#    render tc["deals_photos"].jlt({photos: current_user.company().photos().all()})
#    false
#    
#  @get '#/deals_administrator/photos/new', (context) ->
#    render tc["deals_photos_new"].jlt()
#    false
#
#  @post '#/deals_administrator/photos', (context) ->
#    p = new Photo(context.params.photo)
#    p.attr('owner_type', 'Company')
#    data = new FormData($(@target)[0])
#    if csrf_param()? and csrf_token()?
#      data.append(csrf_param(), csrf_token())
#    # Options to tell JQuery not to process data or worry about content-type
#    ajaxopts =
#      cache: false
#      contentType: false
#      processData: false
#
#    a = $.ajax($.extend({}, ajaxopts,
#      type: "POST"
#      url: "#{R.app_host}/home/deals_administrator/photos"
#      data: data
#      xhr: -> # custom xhr
#        myXhr = $.ajaxSettings.xhr()
#        if (myXhr.upload) # check if upload property exists
#          myXhr.upload.addEventListener('progress',progressHandlingFunction, false)  # for handling the progress of the upload
#        return myXhr
#      success: (data) ->
#        p.merge data
#        p.trigger "update"
#        Photo.add(p)
#        context.redirect "#/deals_administrator/photos"
#        gritter
#          title: "Success!"
#          text: "Photo posted."
#      error: (xhr, code, reason) ->
#        alert "upload error - please supply a valid image"
#    ))
#
#    false
#
#  @get '#/deals_administrator/photos/:id/delete', (context) ->
#    p = Photo.find context.params.id
#    render tc["deals_photo_delete"].jlt(p)
#    false
#        
#  @del '#/deals_administrator/photos/:id', (context) ->
#    p = Photo.find context.params.id
#    p.destroy (success) ->
#      if success
#        context.redirect "#/deals_administrator/photos"
#        gritter
#          title: "Photo Deleted!"
#          text: "Photo ##{p.id()} has been deleted."
#      else
#        context.redirect "#/deals_administrator/photos"
#        # todo, get error message.
#        gritterError("oh oh, couldn't delete photo")
#    false
#
#  @get '#/a_deals', (context) ->
#    deals = if context.params.state?
#      current_user.company().deals().select( -> @state() == context.params.state ).all()
#    else
#      current_user.company().deals().all()
#    render tc["a_deals"].jlt({deals: deals, company: current_user.company(), state: context.params.state})
#    $("a.state_#{context.params.state}").addClass('ui-btn-active')
#    false
#
#  @get '#/a_deals/new', (context) ->
#    render tc["a_deals_new"].jlt(new Deal())
#    false
#
#

)



