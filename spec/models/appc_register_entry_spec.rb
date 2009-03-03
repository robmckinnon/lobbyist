require File.dirname(__FILE__) + '/../spec_helper'

describe AppcRegisterEntry do

  describe 'when data is set' do
    before do
  @data = "#{@organisation_name}
#{@description}
Address(es) in UK
Contact
#{@office_contact}
Website: #{@website}
Offices outside UK
#{@offices_outside_the_uk}
Staff (employed and sub-contracted) providing PA consultancy services this quarter
#{@consultancy_staff_text}
Fee-Paying clients for whom UK PA consultancy services provided this quarter
#{@consultancy_clients_text}
Fee-Paying Clients for whom only UK monitoring services provided this quarter
#{@monitoring_clients_text}"
    end

    it 'should create RegisterEntry correctly' do
      @appc_register_entry.data = @data
      @appc_register_entry.data.should == @data
      @register_entry = @appc_register_entry.register_entry

      @register_entry.organisation_name.should == @organisation_name
      @register_entry.office_contacts.size.should == 1
      @register_entry.office_contacts.first.details.should == @office_contact

      @register_entry.organisation_url.should == @website
      @register_entry.offices_outside_the_uk.should == @offices_outside_the_uk

      staff = []
      @consultancy_staff_text.each_line {|line| staff << line.strip}

      @register_entry.consultancy_staff_members.size.should == staff.size
      staff.each_with_index do |name, index|
        @register_entry.consultancy_staff_members[index].name.should == name
      end

      clients = []
      @consultancy_clients_list.each_line {|line| clients << line.strip}
      @register_entry.consultancy_clients.size.should == clients.size
      clients.each_with_index do |name, index|
        @register_entry.consultancy_clients[index].name.should == name
        if name == 'Business Software Alliance UK'
          @register_entry.consultancy_clients[index].name_in_parentheses.should == 'Adobe, Altium, Apple, Attachmate, Autodesk, Avid, Babylon, Bentley Systems, FrontRange Solutions, CNC, Corel, CyberLink, Dassault Systèmes SolidWorks Corporation, Enteo Software, Famatech, LINKService, Mamut, Materialise Software, Microsoft, Mindjet, Monotype Imaging, O&O Software, Quark, Quest Software, Rosetta Stone, Ringler- Informatik, Scalable Software, Siemens, Staff & Line, Symantec, Tekla, and The MathWorks'
        end
      end

      @register_entry.monitoring_clients.size.should == 0
    end
  end

  before do
    @appc_register_entry = AppcRegisterEntry.new
    @organisation_name = 'APCO Worldwide'
    @description = 'APPC Register Entry for 1 September 2008 to 30 November 2008'
    @office_contact = '90 Long Acre
London
WC2E 9RA
Name:
Tel:
Fax:
Email:
Martin Sawer
020 7526 3620
020 7526 3699
msawer@apcoworldwide.com'
    @website = 'http://www.apcoworldwide.com/uk'
    @offices_outside_the_uk = 'Brussels, Italy, Germany, France, Vietnam, Hong Kong, China, Singapore, Thailand, Indonesia, South Africa, USA, Russia, Canada, Israel, Singapore, India , Poland, Dubai'
    @consultancy_staff_text = 'Alex Bigham
Alice Osborne
Ben Steele
Charlotte Hughes
Darren Murphy
David Clark
Edward Walsh
Fleur Fisher
Flora Monsaingeon
Gerald Power
Isabella Sharp
Jaselle Williams
Jo Bullen
John Mandeville
Jon Chandler
Komel Bajwe
Magdalena Stepien
Maria Lavrova
Martin Sawer
Matt Browne
Maurice Fraser
Maurice Rankin
Mia Early
Michael Philips
Patrick Leahy
Paul Stadlen
Rachel Thompson
Razi Rahman
Roger Hayes
Simon Buckby
Stephanie Lvovich
Steven King
Tamsin Richmond-Watson
Tom Allison
Victor Prokofiev'

    @consultancy_clients_text = '• Abbott Nutrition
• Advertising Education Forum
• ACCURAY Europe
• BodmerFischer Ltd
• Bonita Ventures Limited
• Borealis AG
• British Association of
Pharmaceutical Wholesalers
• Business Software Alliance
UK (Adobe, Altium, Apple,
Attachmate, Autodesk, Avid,
Babylon, Bentley Systems,
FrontRange Solutions, CNC,
Corel, CyberLink, Dassault
Systèmes SolidWorks
Corporation, Enteo Software,
Famatech, LINKService,
Mamut, Materialise Software,
Microsoft, Mindjet, Monotype
Imaging, O&O Software,
Quark, Quest Software,
Rosetta Stone, Ringler-
Informatik, Scalable
Software, Siemens, Staff &
Line, Symantec, Tekla, and
The MathWorks)
• Cleanevent
• Coca-Cola Great Britain
• The Coca-Cola Company
• Creative Direction
Consultants Ltd
• Denplan
• Duninga Developments
• Ebay Inc.
• ESB International Ltd
• Ethicon Endo-Surgery
(Europe) GmbH
• FBC Media UK
• Gate Gourmet Ltd London
• GML Limited
• Housing Corporation/Tenant
Services Authority
• Hughes Hubbard & Reed
LLP
• Humana Europe
• IMS Health
• Johnson Controls Inc.
• Johnson & Johnson
• Media Smart UK Ltd
• Merck Sharp & Dohme Ltd
• Medicines for Malaria Venture
• Microsoft
• Netjets Europe
• Nike Inc
• Norilsk Nickel
• OTE Hellenic
Telecommunications
Organization
• Phadia UK
• Plastics Europe
• SABMiller Plc
• Solvay Pharmaceuticals
GMBH
• Tyco Electronics
• Virgin Healthcare
• Wyeth Pharmaceuticals'

    @consultancy_clients_list = 'Abbott Nutrition
Advertising Education Forum
ACCURAY Europe
BodmerFischer Ltd
Bonita Ventures Limited
Borealis AG
British Association of Pharmaceutical Wholesalers
Business Software Alliance UK
Cleanevent
Coca-Cola Great Britain
The Coca-Cola Company
Creative Direction Consultants Ltd
Denplan
Duninga Developments
Ebay Inc.
ESB International Ltd
Ethicon Endo-Surgery (Europe) GmbH
FBC Media UK
Gate Gourmet Ltd London
GML Limited
Housing Corporation/Tenant Services Authority
Hughes Hubbard & Reed LLP
Humana Europe
IMS Health
Johnson Controls Inc.
Johnson & Johnson
Media Smart UK Ltd
Merck Sharp & Dohme Ltd
Medicines for Malaria Venture
Microsoft
Netjets Europe
Nike Inc
Norilsk Nickel
OTE Hellenic Telecommunications Organization
Phadia UK
Plastics Europe
SABMiller Plc
Solvay Pharmaceuticals GMBH
Tyco Electronics
Virgin Healthcare
Wyeth Pharmaceuticals'

    @monitoring_clients_text = "• None"
  end
end
