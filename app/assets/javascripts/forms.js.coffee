
$ = jQuery

$document = $(document)

$document.on 'click vclick tap', 'a.spin', (event) ->
  $.mobile.loading 'show', { theme: "b", text: "processing..." }


# moment.js custom config

window.moment.longDateFormat =
    LT: "h:mm A",
    L: "DD/MM/YYYY",
    LL: "MMMM D YYYY",
    LLL: "MMMM D YYYY LT",
    LLLL: "dddd, MMMM D YYYY LT"

window.moment.calendar =
  lastDay : '[Yesterday at] LT'
  sameDay : '[Today at] LT'
  nextDay : '[Tomorrow at] LT'
  lastWeek : '[last] dddd [at] LT'
  nextWeek : 'dddd [at] LT'
  sameElse : 'L [at] LT'

window.fromNowUpdate = ->
  $('time.fromNow').each ->
    $this = $(this)
    if dt = $this.attr('datetime')
      $this.text  moment(dt).fromNow()

window.fromNowUpdateIntervalId = setInterval( fromNowUpdate, 10000 )

$document.on 'click vclick tap',  'a#bid_now', (event) ->
  event.preventDefault()
  $(this).closest('form').submit()

