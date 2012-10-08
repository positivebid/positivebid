
class Sview

  @tc = {}

  constructor: (template_name, data) ->
    @template_name = template_name
    #jlt @html = Sview.tc[@template_name].clone()
    @html = window.tc[@template_name].jlt(data)
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


#jlt $(document).ready ->
#jlt   $("#templates").remove().children().each ->
#jlt     $this = $(this)
#jlt     Sview.tc[$this.attr("id")] = $this.children()

