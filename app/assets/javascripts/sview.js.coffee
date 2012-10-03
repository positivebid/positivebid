
class Sview

  @tc = {}

  constructor: (template_name, data) ->
    @template_name = template_name
    @html = Sview.tc[@template_name].clone()
    @rivet = rivets.bind(@html, data)

  rerender: ->
    new_html = Sview.tc[@template_name].clone()
    new_rivet = rivets.bind(new_html, data)
    @html.replaceWith(new_html)
    @rivet.unbind()
    @rivit = new_rivet

  destroy: ->
    @rivet.unbind()
    @html?.remove()

window.Sview = Sview


$(document).ready ->
  $("#templates").remove().children().each ->
    $this = $(this)
    Sview.tc[$this.attr("id")] = $this.children()

