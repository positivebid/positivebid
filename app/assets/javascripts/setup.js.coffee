PB = window.PB ||= {}

$document = $(document)


$document.bind 'mobileinit', () ->

  $.support.cors = true

  $.extend $.mobile,
    ajaxEnabled: false
    allowCrossDomainPages: true
    autoInitializePage: false
    hashListeningEnabled: false
    linkBindingEnabled: false
    pushStateEnabled: false
    defaultPageTransition: 'none'


  $document.on 'tap click', '[sam]', (event) ->
    $link = $(this)
    window.reverse_back = ($link.attr('data-direction') == 'reverse')
    app.runRoute $link.attr("method") or "get", $link.attr("sam")
    event.preventDefault()
    #return false

rivets.configure({ prefix: 'rv' })

$document = $(document)

$document.ajaxStart -> $.mobile.loading('show')
$document.ajaxStop -> $.mobile.loading('hide')


PB.domready = ->
  PB.$body = $('body')
  $('script').remove()
  $.mobile.initializePage()
  setTimeout ->
    #$('div.ui-page:not(.ui-page-active)').remove() # remove inital page.
    
    window.R ?=
      app_host: ''

    #if PhoneGap?
    # assign_rest R.app_host
    #else
    # assign_rest()
    #loadR R

    setTimeout ->
      if current_user?
        PB.app.run "#/reload"
      else
        PB.app.run "#/reload"
    , 200
    PB.status.check_and_bind()
  , 0


jQuery ->
  PB.domready()

