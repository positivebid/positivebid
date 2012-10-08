
$ = jQuery

$document = $(document)

$document.on 'click vclick tap', 'a.spin', (event) ->
  $.mobile.loading 'show', { theme: "b", text: "processing..." }

