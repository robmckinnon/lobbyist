namespace :wl do

  desc "load register"
  task :load_registers => :environment do
    file_names = [Dir.glob(RAILS_ROOT + '/data/members_register/reg*').last]

    file_names.each do |file_name|
      doc = Hpricot open(file_name)
      entries = (doc/'/publicwhip/regmem')
      
      data_source = DataSource.get_data_source(file_name)
      puts data_source.name
      
      entries.each do |data|
        person = Person.find_by_publicwhip_id(data['personid'])
        member = Member.find_by_publicwhip_id(data['memberid'])
        
        puts "person not found: #{data['personid']}" unless person
        puts "member not found: #{data['memberid']}" unless member
        
        unless !person || !member || MembersInterestsEntry.exists?(:member_id => member.id, :data_source_id => data_source.id)
          puts member.firstname.to_s + ' ' + member.lastname.to_s
          entry = MembersInterestsEntry.create!({ :member_id => member.id, :data_source_id => data_source.id })
          categories = (data/'category')
          categories.each do |category_data|
            category = MembersInterestsCategory.find_or_create_by_number_and_name(category_data['type'], category_data['name'])
            items = (category_data/'item')
            
            items.each do |item_data|
              subcategory = item_data['subcategory']
              item = MembersInterestsItem.new :members_interests_category_id => category.id,
                  :members_interests_entry_id => entry.id,
                  :subcategory => subcategory
              item.text = item_data.inner_text
              item.save!
            end
          end
        end
      end
    end
  end
  
  desc "Load publicwhip person data"
  task :load_people => :environment do
    doc = Hpricot open(RAILS_ROOT + '/data/members_register/people.xml')    
    people = (doc/'/publicwhip/person')
    
    people.each do |data|
      publicwhip_id = data['id']
      unless Person.exists?(:publicwhip_id => publicwhip_id)
        person = Person.create!({ :publicwhip_id => publicwhip_id,
            :name => data['latestname']})
        puts person.name
        offices = (data/'office')
        offices.each do |office|
          if office['id'].include?('uk.org.publicwhip/member/')
            member = Member.find_by_publicwhip_id(office['id'])
            if member
              member.person_id = person.id
              member.save!
            else
              puts 'member not found: ' + office['id']
            end
          end
        end
      end
    end
  end

  desc "Load publicwhip members data"
  task :load_members => :environment do
    file_name = Dir.glob(RAILS_ROOT + '/data/members_register/all-members.xml').last
    doc = Hpricot open(file_name)    
    members = (doc/'/publicwhip/member')
    
    members.each do |data|
      publicwhip_id = data['id']
      unless Member.exists?(:publicwhip_id => publicwhip_id)
        member = Member.create!( { :publicwhip_id => publicwhip_id,
            :person_id => nil,
            :house => data['house'],
            :title => data['title'],
            :firstname => data['firstname'],
            :lastname => data['lastname'],
            :constituency => data['constituency'],
            :party => data['party'],
            :from_why => data['fromwhy'],
            :to_why => data['towhy'],
            :from_date => Date.parse(data['fromdate']),
            :to_date => Date.parse(data['todate']) })
        puts member.firstname.to_s + ' ' + member.lastname.to_s
      end

    end
  end
end
