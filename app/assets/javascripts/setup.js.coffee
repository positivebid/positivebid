
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



rivets.configure({ prefix: 'rv' })

$ ->
  PB.$body = $('body')
  $('script').remove()
  $.mobile.initializePage()
  #Backbone.history.start()
  PB.app.run "#/auctions"
  $('div.ui-page:not(.ui-page-active)').remove() # remove inital page.
  #Backbone.history.navigate()



