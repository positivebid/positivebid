module HelplinksHelper

  def helplink( key, text = "")
    "<a class=\"btn btn-helplink\" data-helplink=\"#{key}\"><i class=\"icon-info-sign helplink #{key}\"></i>#{text}</a>".html_safe
  end

end
