
$ = jQuery

window.progressHandlingFunction = (e) ->
  if e.lengthComputable
    $('progress').attr({value:e.loaded,max:e.total})

window.nice_date = (string) ->
  if string? and string != ""
    moment(string).format("dddd, D MMM YYYY")
  else
    ""

window.nice_datetime = (string) ->
  if string? and string != ""
    moment(string).format("dddd, D MMM YYYY h:m A")
  else
    ""

window.nice_time = (mins) ->
  h = (parseInt(mins/60,10))%12
  h = 12 if h == 0
  "#{h}:#{D2(mins%60)} #{if mins < 720 then 'AM' else 'PM'}"



$ ->


  $('input.ui-date-picker').datepicker({ dateFormat: 'yy-mm-dd'})

  $('input.ui-date-picker').bind 'change', ->
    $this = $(this)
    $this.closest('div').find('span.hint').text(nice_date($this.val()))

  $('input.ui-datetime-picker').datetimepicker({ dateFormat: 'yy-mm-dd'})

  $('input.ui-datetime-picker').bind 'change', ->
    $this = $(this)
    $this.closest('div').find('span.hint').text(nice_datetime($this.val()))
  
  $('span.countdown').each ->
    $this = $(this)
    duetime = moment.unix(parseInt($this.data('duedate'),10))
    update_text = ->
      duration = moment.duration( duetime - moment() )
      string = "#{if duration.days() > 0 then "#{duration.days()} day#{if duration.days() != 1 then "s" else ""} " else ""}"  +
        "#{if duration.hours() > 0 then "#{duration.hours()} hour#{if duration.hours() != 1 then "s" else ""} " else ""}"  +
        "#{if duration.minutes() > 0 then "#{duration.minutes()} minute#{if duration.minutes() != 1 then "s" else ""} " else "" }"  +
        "#{duration.seconds()} second#{if duration.seconds() != 1 then "s" else ""}"

      $this.text string

    update_text()
    interval_id = window.setInterval update_text, 1000



