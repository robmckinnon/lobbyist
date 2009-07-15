require File.dirname(__FILE__) + '/../spec_helper'

describe MembersInterestsItem do

  describe 'when creating from line' do
    before do
      @item = MembersInterestsItem.new
    end
    
    def set_text text
      @item.text= text
      @item.description.should == text.sub(/(\(Registered ([^\)]+)\))/,'').strip
    end

    it 'should take text' do
      set_text "May 2008, fees as a presenter on BBC One's 'This Week' programme, ongoing.  (Actual &pound;2,457). (Registered 25 June 2008)"

      @item.registered_date_text.should == "(Registered 25 June 2008)"
      @item.registered_date.should == Date.new(2008,6,25)
      @item.actual_amount_text.should == "(Actual &pound;2,457)"
      @item.actual_amount.should == 2457
      @item.currency_symbol.should == "£"
    end
    
    it 'should handle actual and up to' do
      set_text "October 2008, fees for three Arcadia Lectures for the School of Oriental and Asian Studies, London. (Actual &pound;900) (Up to &pound;5,000) (Registered 4 November 2008)"

      @item.registered_date_text.should == "(Registered 4 November 2008)"
      @item.registered_date.should == Date.new(2008,11,4)
      @item.actual_amount_text.should == "(Actual &pound;900)"
      @item.actual_amount.should == 900
      @item.up_to_amount_text.should == "(Up to &pound;5,000)" 
      @item.up_to_amount.should == 5000
      @item.currency_symbol.should == "£"
    end

    it 'should handle receive some dosh' do
      set_text "Articles in:  Catholic Herald, Country Life, Estates Gazette, Planning, Evening Standard.  I also chair conferences.  The subjects in both cases are usually property, sustainable development and religious issues.  The commitments arise largely from my previous profession of journalism and all payments go to Sancroft which provides research staff, information services, and all other facilities.  Currently Sancroft would expect about &pound;100,000 in payments, in respect of which I would receive some &pound;30,000 in fees and dividends."
      @item.from_amount_text.should == 'would receive some &pound;30,000'
      @item.from_amount.should == 30000
      @item.currency_symbol.should == "£"
    end

    it 'should handle annual fee' do
      set_text "Parliamentary Consultant to Scottish Coal, Bain Square, Livingston EH54 7DQ. (&pound;5,001-&pound;10,000)  I receive a retaining annual fee of &pound;7,500 as a Parliamentary Consultant to advise on parliamentary matters as they pertain to the coal industry, payable in equal monthly instalments."
      @item.actual_amount_text.should == 'receive a retaining annual fee of &pound;7,500'
      @item.actual_amount.should == 7500
      @item.currency_symbol.should == "£"
    end

    it 'should ignore per article payment' do
      set_text "I write a column for The Morning Advertiser every five weeks (&pound;250 per article). (Up to &pound;5,000)"
      @item.up_to_amount_text.should == "(Up to &pound;5,000)"
      @item.up_to_amount.should == 5000
      @item.currency_symbol.should == "£"
    end

    it 'should not process other things in brackets' do
      set_text "Member of Lloyd's (resigned as from 31 December 2002)."
      set_text "Chairman of the Conservative Friends of Israel (unremunerated)."
      set_text "Director of CAABU (The Council for the Advancement of Arab-British Understanding Ltd.) (appointed 25 November 2004)."
      set_text "Self-employed partner in family farming business at Lower Aynho Grounds (see item 8)."
    end
    
    it 'should handle just description' do
      set_text "Trustee of the Industry and Parliament Trust."
    end
    
    it 'should handle just up to' do
      set_text "I was until 1 April 2009 the Chair of One Nottingham, which is Nottingham's regeneration board.  (Up to &pound;5,000)"
      @item.up_to_amount_text.should == "(Up to &pound;5,000)" 
      @item.up_to_amount.should == 5000
      @item.currency_symbol.should == "£"
    end

    it 'should handle amount range' do
      set_text "October 2008, fees as a presenter on BBC One's 'This Week' programme, ongoing. (Actual &pound;5,733) (&pound;5,001-&pound;10,000) (Registered 4 November 2008)"
      @item.registered_date_text.should == "(Registered 4 November 2008)"
      @item.registered_date.should == Date.new(2008,11,4)
      @item.actual_amount_text.should == "(Actual &pound;5,733)"
      @item.actual_amount.should == 5733
      @item.range_amount_text.should == "(&pound;5,001-&pound;10,000)"
      @item.from_amount.should == 5001
      @item.up_to_amount.should == 10000
      @item.currency_symbol.should == "£"
    end
  end

end
