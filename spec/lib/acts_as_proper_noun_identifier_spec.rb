# coding:utf-8
require File.dirname(__FILE__) + '/../../lib/acts_as_proper_noun_identifier.rb'
require File.dirname(__FILE__) + '/../spec_helper'

describe Acts::ProperNounIdentifier do

  before(:all) do
    eval('class PNI; end')
    PNI.send(:include, Acts::ProperNounIdentifier)
    ignore = ['Senior','Adviser','Consultant','Contract','Fees','Deputy',
        'Managing','Director','Chairman','Director','Registered','Author',
        'Secretary','Registered','Up','Currently']
    @ignore = ignore
  end

  describe 'when asked to identify proper nouns' do

    def proper_nouns text, matches, ignore_in_quotes=false, size=nil
      @nouns = PNI.proper_nouns(text, :ignore=>@ignore, :ignore_in_quotes=>ignore_in_quotes, :ignore_dates => true)
      matches.each_with_index do |match, index|
        @nouns[index].should == match
      end
      @nouns.each_with_index do |noun, index|
        matches[index].should == noun
      end
      if size
        @nouns.size.should == size
      end
    end

    it 'should find em' do
      proper_nouns 'Managing Director and controlling interest in Mowthorpe (UK) Ltd; the company operates a green/woodland cemetery on land which was previously part of Southwood Farm, Terrington, in NorthYorkshire.',
          ['Mowthorpe (UK) Ltd',
          'Southwood Farm',
          'Terrington',
          'NorthYorkshire']
    end

    it 'should keep all-parliamentary groups intact' do
      proper_nouns "6-11 September 2008, to Dharamsala, India, to visit the Tibetan Government-in-exile in my capacity as the Vice-Chair of the All-Party Parliamentary Group for Tibet and as President of the Tibet Society.",
          ['Dharamsala',
          'India',
          'Tibetan Government-in-exile',
          'Vice-Chair',
          'All-Party Parliamentary Group for Tibet',
          'President',
          'Tibet Society']
    end

    it 'should find all' do
      proper_nouns 'Director, International School for Security and Explosives Education (ISSEE) (non-executive).',
          ['International School for Security and Explosives Education',
          'ISSEE']
    end

    it 'should spot all' do
      proper_nouns 'Since May 1997, occasional briefing and visits to the House in connection with particular legislation by Mr Simon Calvert, Deputy Director of the Christian Institute.',
          ['Since',
          'House',
          'Mr Simon Calvert',
          'Christian Institute']
    end

    it 'should do ignore Chairman' do
      proper_nouns 'A member of staff is seconded by KPMG to work in the Policy Unit of the Conservative Party, working to the Director of Policy and Research; I am Chairman of the Policy Review',
          ['KPMG',
          'Policy Unit',
          'Conservative Party',
          'Policy and Research',
          'Policy Review']
    end

    it 'should ignore chair of advisory committee' do
      proper_nouns 'Chair of Advisory Committee Entrust Inc.',
        ['Chair of Advisory Committee Entrust Inc']
    end

    it 'should handle 2009.' do
      proper_nouns "£625 received 1 July 2009.  Hours worked nil.",
          ['Hours']
    end

    it 'should include numbers' do
      proper_nouns 'I was the guest of Mr Richard Phillips, Managing Director of Silverstone Circuits Limited at the Formula 1 British Grand Prix on 6 July 2008. (Registered 22 July 2008)',
          ['Mr Richard Phillips',
          'Silverstone Circuits Limited',
          'Formula 1 British Grand Prix']
    end

    it 'should ignore :.' do
      proper_nouns 'Categories of business underwritten until resignation - CBS Private Capital Ltd.:  All categories.',
          ['Categories',
          'CBS Private Capital Ltd',
          'All']
    end

    it 'should split on ,' do
      proper_nouns 'Senior adviser to the management team of the Fluor Corporation, London (until 30 June 2009).  (£110,000-£115,000) (See Category 1 above).',
          ['Fluor Corporation',
          'London',
          'See Category 1']

      proper_nouns 'Senior Adviser, Cinven. (£55,001-£60,000)',
          ['Cinven']
    end

    it 'should join HADAW Productions and Investments Ltd' do
      proper_nouns 'Director HADAW Productions and Investments Ltd',
        ['HADAW Productions and Investments Ltd']
    end

    it 'should split on (' do
      proper_nouns 'Consultant to Electronic Data Systems Ltd (EDS); provision of IT services to public and private sector clients in the UK.  (£50,001-£55,000)',
          ['Electronic Data Systems Ltd',
          'EDS',
          'IT',
          'UK']
    end

    it 'should handle &' do
      proper_nouns 'Advance under contract with Hodder & Stoughton for autobiographical book.  (£35,001-£40,000)',
          ['Advance',
          'Hodder & Stoughton']
    end

    it 'should not add (Up' do
      proper_nouns 'Training for the National School of Government. (Up to £5,000)',
          ['Training',
          'National School of Government']

          proper_nouns 'Washington Post (Up to £5,000)',
          ['Washington Post']
    end

    it 'should split on commas' do
      proper_nouns 'Articles in:  Catholic Herald, Country Life, Estates Gazette, Planning, Evening Standard.  I also chair conferences.  The subjects in both cases are usually property, sustainable development and religious issues.  The commitments arise largely from my previous profession of journalism and all payments go to Sancroft which provides research staff, information services, and all other facilities.  Currently Sancroft would expect about £100,000 in payments, in respect of which I would receive some £30,000 in fees and dividends.',
        ['Articles',
        'Catholic Herald',
        'Country Life',
        'Estates Gazette',
        'Planning',
        'Evening Standard',
        'Sancroft']
    end

    it 'should strip conferences and dinners' do
      proper_nouns '8 October 2008, speech at the Mortgage Intelligence Annual Conference dinner in Newport. (£10,001-£15,000)',
        ['Mortgage Intelligence',
        'Newport']

      proper_nouns "1 December 2008, hosted the Institute of Turnaround Professionals' Awards Dinner in London. (£15,001-£20,000)",
        ['Institute of Turnaround Professionals',
        'London']

      proper_nouns "19 September 2008, speech at the Azur Business Networking Lunch in London. (£10,001-£15,000)",
        ['Azur Business',
        'London']
    end

    it 'should not merge date in to result' do
      proper_nouns "November 2008, fees as a presenter on BBC One's 'This Week' programme, ongoing. (Actual £4,457) (Up to £5,000)",
          ['BBC One',
          'This Week',
          'Actual']
    end

    it 'should ignore in quotes when asked to' do
      proper_nouns("Advance on contract with Orion Books for a book on 'Globalising Hatred'. (£10,001-£15,000)",
        ['Advance',
        'Orion Books'],
        true, 2)
    end

    it 'should not ignore in quotes when asked to' do
      proper_nouns("Advance on contract with Orion Books for a book on 'Globalising Hatred'. (£10,001-£15,000)",
        ['Advance',
        'Orion Books',
        'Globalising Hatred'],
        false)
    end

    it 'should ignore Parliamentary Adviser' do
      proper_nouns('Parliamentary Adviser to the Caravan Club. (£5,001-£10,000)',
        ['Caravan Club'])
    end

    it 'should ignore Author.' do
      proper_nouns("Author.",
        [])
    end

    it 'should split on full-stop' do
      proper_nouns("20-22 May 2008, to Australia, to address a conference on domestic violence in Canberra.  Return flights to Australia and accommodation in Canberra paid for by the ACT Government.",
        ['Australia','Canberra','Return','ACT Government'])
    end

    it 'should handle organisations starting with digit' do
      proper_nouns('3DM PLC', ['3DM PLC'])
    end

    it 'should behave this way' do
      proper_nouns('19-22 September 2008, attendance at the Ryder Cup in the USA in my capacity as Secretary of the Parliamentary Golf Society. Travel and accommodation paid by Humana Europe, a healthcare services company.',
        ['Ryder Cup','USA','Parliamentary Golf Society','Travel','Humana Europe'])
    end

  end
end
