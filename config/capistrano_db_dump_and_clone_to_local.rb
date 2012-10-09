# HACKED by jason, run the back with: cap production db:clone_to_local
Capistrano::Configuration.instance(:must_exist).load do

  namespace :db do

    task :daily_name, :roles => :db, :only => { :primary => true } do
      run "mkdir -p #{shared_path}/db_backups"
      if Time.now.day == 1
        backup_day = "#{Time.now.strftime("%d%B")}"
      else
        backup_day = "#{Time.now.day}"
      end
      set :backup_file, "#{environment_database}-snapshot-#{backup_day}.sql"
      set :backup_file_fullpath, "#{shared_path}/db_backups/#{backup_file}"
    end

    task :backup_name, :roles => :db, :only => { :primary => true } do
      now = Time.now
      run "mkdir -p #{shared_path}/db_backups"
      backup_time = [now.year,now.month,now.day,now.hour,now.min,now.sec].join('-')
      set :backup_file, "#{environment_database}-snapshot-#{backup_time}.sql"
      set :backup_file_fullpath, "#{shared_path}/db_backups/#{backup_file}"
    end

    task :set_environment_info, :roles => :db, :only => { :primary => true } do
      run("cat #{current_path}/config/database.yml") { |channel, stream, data| @environment_info = YAML.load(data)['production'] }
      set :environment_database,  @environment_info['database']
    end


    desc "Backup your MySQL or PostgreSQL database to shared_path+/db_backups"
    task :dump, :roles => :db, :only => {:primary => true} do
      dbuser = @environment_info['username']
      dbpass = @environment_info['password']
      dbhost = @environment_info['host'] || 'localhost'
      run "pg_dump -W -c -U #{dbuser} -h #{dbhost} #{environment_database} | bzip2 -c > #{backup_file_fullpath}.bz2" do |ch, stream, out |
        ch.send_data "#{dbpass}\n" if out=~ /^Password:/
      end
    end

    desc "Daily backup and copy of dump file to be run on the staging server"
    task :daily_dump, :roles => :db, :only => {:primary => true} do
      set_environment_info
      daily_name
      dump
      # make sure ../remote_backups/   exists
      saveto = ENV['SAVETO'] || '../remote_backups'
      get "#{backup_file_fullpath}.bz2", "#{saveto}/#{backup_file}.bz2"
    end

    desc "Sync your production database to your local workstation"
    task :clone_to_local, :roles => :db, :only => {:primary => true} do
      set_environment_info
      backup_name
      dump
      get "#{backup_file_fullpath}.bz2", "./tmp/#{backup_file}.bz2"
      localdb = 'production'
      development_info = YAML.load_file("config/database.yml")[localdb]
      puts run_str = "PGPASSWORD=#{development_info['password']} bzcat ./tmp/#{backup_file}.bz2 | psql -U #{development_info['username']} -h #{development_info['host'] || 'localhost'} #{development_info['database']}"
      %x!#{run_str}!
    end

  end
end
