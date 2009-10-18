require 'fastercsv'

namespace :wl do

  task :write_interests => :environment do
    MembersInterestsItem.write_to_tsv
  end

  task :load_spads => :environment do
    Dir.glob('/Users/x/apps/lobbying/lobbyist/data/special_advisors/*.html') do |file|
      puts "loading #{file}"
      ignore_third_column = file[/50721m12/]
      # unless ignore_third_column
        if file[/40722-24/]
          SpecialAdvisorList.load_file file, ignore_third_column
        end
      # end
    end
  end

  desc 'load acoba appointments'
  task :load_acoba => :environment do
    person = nil
    previous_name = nil
    FasterCSV.foreach(RAILS_ROOT + "/data/acoba/ministers_acobaninthreport2006_08.csv", :headers=>true) do |data|
      data = data.to_hash
      data.symbolize_keys!
      if name = data[:name]
        unless person = Member.from_name(name) || Lord.from_name(name)
          print name + ': '
          print 'not found'
          puts ''
        end
      end
      if person
        previous_name = name if name
        Appointee.create_from previous_name, person, data
      else
        puts "not creating: " + data.inspect
      end
    end
  end

  desc 'load quangos'
  task :load_quangos => :environment do
    FasterCSV.foreach(RAILS_ROOT + "/data/uk_quangos_2007.csv", :headers=>true) do |q|
      quango = Quango.create_if_new :department => q["Department"],
        :name => q["Name"].strip,
        :alternate_name => q["Name With Prefix At End"],
        :quango_type => q["Type"],
        :focus => q["Focus"],
        :url => q["Website"],
        :source => q["Source"]
    end
  end

  desc "load register"
  task :load_registers => :environment do
    file_names = [Dir.glob(RAILS_ROOT + '/data/regmem/reg*').last]

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
          unless member.person
            member.person_id = person.id
            member.save
          end
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

  task :load_offices => :environment do
    doc = Hpricot open(RAILS_ROOT + '/data/members/people.xml')
    people = (doc/'/publicwhip/person')
    people.each do |data|
      publicwhip_id = data['id']
      if person = Person.find_by_publicwhip_id(publicwhip_id)
        puts person.name
        (data/'office').each do |office|
          if office['id'].include?('uk.org.publicwhip/lord/')
            if lord = Lord.find_by_publicwhip_id(office['id'])
              lord.person_id = person.id
              lord.save!
            else
              puts 'lord not found: ' + office['id']
            end
          end
        end
      else
        puts "person not found: #{publicwhip_id}"
      end
    end
  end

  desc "Load publicwhip person data"
  task :load_people => :environment do
    doc = Hpricot open(RAILS_ROOT + '/data/members/people.xml')
    people = (doc/'/publicwhip/person')

    people.each do |data|
      publicwhip_id = data['id']
      offices = (data/'office')
      members = []
      offices.each do |office|
        member_publicwhip_id = office['id']
        if member_publicwhip_id.include?('uk.org.publicwhip/member/')
          if member = Member.find_by_publicwhip_id(member_publicwhip_id)
            members << member
          else
            puts 'member not found: ' + office['id']
          end
        end
      end

      if Person.exists?(:publicwhip_id => publicwhip_id)
        person = Person.find_by_publicwhip_id(publicwhip_id)
        if members.size == 0
          puts 'removing: ' + person.inspect
          person.destroy
        else
          members.select{|m| !m.person_id }.each do |member|
            member.person_id = person.id
            member.save!
          end
        end
      elsif members.size > 0
        person = Person.create!({ :publicwhip_id => publicwhip_id,
            :name => data['latestname']})
        puts person.name
        members.each do |member|
          member.person_id = person.id
          member.save!
        end
      end
    end
  end

  desc "Load publicwhip members data"
  task :load_members => :environment do
    file_name = Dir.glob(RAILS_ROOT + '/data/members/all-members.xml').last
    doc = Hpricot open(file_name)
    members = (doc/'/publicwhip/member')

    members.each do |data|
      publicwhip_id = data['id']
      unless Member.exists?(:publicwhip_id => publicwhip_id)
        begin
          from_date = Date.parse(data['fromdate'])
        rescue
          puts 'problem parsing date: ' + from_date.to_s
        end
        if from_date && from_date.year >= 1980
          puts data['firstname'].to_s + ' ' + data['lastname'].to_s

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
              :from_date => from_date,
              :to_date => Date.parse(data['todate']) })
        end
      end

    end
  end

  desc "Load publicwhip lords data"
  task :load_lords => :environment do
    file_name = Dir.glob(RAILS_ROOT + '/data/members/peers-ucl.xml').last
    doc = Hpricot open(file_name)
    lords = (doc/'/publicwhip/lord')

    lords.each do |data|
      publicwhip_id = data['id']
      unless Lord.exists?(:publicwhip_id => publicwhip_id)
        begin
          puts publicwhip_id
          from = data['fromdate']
          is_only_year = from[/^\d\d\d\d$/]
          from_year = is_only_year ? from.to_i : nil
          from_date = is_only_year ? nil : Date.parse(from)
        rescue
          puts 'problem parsing date: ' + from_date.to_s
        end
        if from_date || from_year
          puts data['title'].to_s + ' ' + data['lordofname_full'].to_s

          lord = Lord.create!( { :publicwhip_id => publicwhip_id,
              :person_id => nil,
              :house => data['house'],
              :title => data['title'],
              :forenames => data['forenames'],
              :forenames_full => data['forenames_full'],
              :surname => data['surname'],
              :affiliation => data['affiliation'],
              :lord_name => data['lordname'],
              :lord_of_name => data['lordofname'],
              :lord_of_name_full => data['lordofname_full'],
              :county => data['county'],
              :peerage_type => data['peeragetype'],
              :ex_mp => (data['ex_MP'] == 'yes'),
              :from_why => data['fromwhy'],
              :to_why => data['towhy'],
              :from_year => from_year,
              :from_date => from_date,
              :to_date => Date.parse(data['todate']) })
        end
      end

    end
  end

end
