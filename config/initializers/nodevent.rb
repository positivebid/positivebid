config = YAML::load(File.open(File.join(Rails.root, "/config/nodevent.yml")))[Rails.env]
NoDevent::Emitter.config = config
