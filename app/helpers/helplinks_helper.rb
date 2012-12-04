module HelplinksHelper

  def helplink( key)
    "<a class=\"btn btn-helplink\" data-helplink=\"#{key}\"><i class=\"icon-info-sign helplink #{key}\"></i></a>".html_safe
  end

end
