
$(document).on 'click', 'a.btn-helplink',  (event) ->
  $this = $(this)
  if $this.data('helplinked')
    #$this.popover('toggle') # bug in bootstrap.
    if $this.data('shown')
      $this.popover('hide')
      $this.data('shown', false)
    else
      $this.popover('show')
      $this.data('shown', true)
  else
    $this.popover
      html: true
      title: "Default Title"
      content: "Default Content"
      content: "Default Content"
      trigger: 'manual'
    $this.data('helplinked', true)
    $this.data('shown', true)
    $this.popover 'show'

