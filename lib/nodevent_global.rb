
module NodeventGlobal

  def self.included(base)
    base.after_create :emit_create
    base.after_update :emit_update
  end
    

  def emit_create
    NoDevent::Emitter.emit('global_room', "#{self.class.name.underscore.pluralize}:create", self )
  end

  def emit_update
    NoDevent::Emitter.emit('global_room', "#{self.class.name.underscore}/#{id}:update", self )
  end

end
