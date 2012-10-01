module FunSingletonActions
  include FunActions

  undef index

  # DELETE /event
  # DELETE /event.xml
  def destroy
    self.resource = destroy_resource
    respond_to do |format|
      format.html do
        flash[:notice] = "#{resource_name.humanize} was successfully destroyed."
        redirect_to enclosing_resource_url if enclosing_resource
      end
      format.js
      format.json { head :no_content }
    end
  end
end
