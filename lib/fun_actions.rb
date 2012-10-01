module FunActions

  # GET /events
  # GET /events.json
  def index
    self.resources = find_resources

    respond_to do |format|
      format.html # index.rhtml
      format.js
      format.json { render json: resources }
    end
  end

  # GET /events/1
  # GET /events/1.json
  def show
    self.resource = find_resource

    respond_to do |format|
      format.html # show.erb.html
      format.js
      format.json { render json: resource }
    end
  end

  # GET /events/new
  def new
    self.resource = new_resource

    respond_to do |format|
      format.html # new.html.erb
      format.js
      format.json { render json: resource }
    end
  end

  # GET /events/1/edit
  def edit
    self.resource = find_resource
    respond_to do |format|
      format.html # edit.html.erb
      format.js
      format.json { render json: resource }
    end
  end

  # POST /events
  # POST /events.json
  def create
    self.resource = new_resource

    respond_to do |format|
      if resource.save
        format.html do
          flash[:notice] = "#{resource_name.humanize} was successfully created."
          redirect_to resource_url
        end
        format.js
        format.json { render json: resource, status: :created }
        #format.json { render json: resource, status: :created, location: @list } }
      else
        format.html { render :action => "new" }
        format.js   { render :action => "new" }
        format.json { render json: resource.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /events/1
  # PUT /events/1.json
  def update
    self.resource = find_resource

    resource_form_name = ActiveModel::Naming.singular(resource_class)
    attributes = params[resource_form_name] || params[resource_name] || {}

    respond_to do |format|
      if resource.update_attributes(attributes)
        format.html do
          flash[:notice] = "#{resource_name.humanize} was successfully updated."
          redirect_to resource_url
        end
        format.js
        format.json { render json: resource, status: :ok }
      else
        format.html { render :action => "edit" }
        format.js   { render :action => "edit" }
        format.json { render json: resource.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1
  # DELETE /events/1.json
  def destroy
    self.resource = destroy_resource
    respond_to do |format|
      format.html do
        flash[:notice] = "#{resource_name.humanize} was successfully destroyed."
        redirect_to resources_url
      end
      format.js
      format.json { head :no_content }
    end
  end

end
