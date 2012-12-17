# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


# generate new faq_seed_data.rb from database with
#
#
s = 'FAQS = [' + Faq.all.sort_by{|p| p.key}.map{|p| pa = p.attributes.reject{|k,v| k.match(/^(updated_at|created_at|id)$/)}; pa['questions_attributes'] =  p.questions.map{|p| p.attributes.reject{|k,v| v.blank? or k.match(/^(updated_at|created_at|id|faq_id)$/)} } ;  pa.awesome_inspect(:plain => true, :index => false, :sort_keys => true)}.join(',')  + ']'
#
# f = File.open("db/faq_seed_data.rb", "w"); f.write(s); f.close

require './db/faq_seed_data'

FAQS.each do |attrs|
  if p = Faq.find_by_key(attrs['key'])
    p.attributes = attrs
    if p.changed?
      puts "saving updated Faq #{attrs['key']}"
      p.save!
    end
  else
    puts "creating FAQ #{attrs['key']}"
    Faq.create!(attrs)
  end
end


# s = 'HELPS = [' + Helplink.all.sort_by{|p| p.key}.map{|p| p.attributes.reject{|k,v| k.match(/^(updated_at|created_at|id)$/)}.awesome_inspect(:plain => true, :sort_keys => true)}.join(',')  + ']'
#
#f = File.open("db/helplinks_seed_data.rb", "w"); f.write(s); f.close

require './db/helplinks_seed_data'

HELPS.each do |attrs|
  if p = Helplink.find_by_key(attrs['key'])
    p.attributes = attrs
    if p.changed?
      puts "saving updated Helplink #{attrs['key']}"
      p.save!
    end
  else
    puts "creating Helplink #{attrs['key']}"
    Helplink.create!(attrs)
  end
end
