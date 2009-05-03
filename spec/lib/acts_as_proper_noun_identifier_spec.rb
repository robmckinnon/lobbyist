require File.dirname(__FILE__) + '/../../lib/acts_as_proper_noun_identifier.rb'
require File.dirname(__FILE__) + '/../spec_helper'

describe Acts::ProperNounIdentifier do

  before(:all) do
    eval('class PNI; end')
    PNI.send(:include, Acts::ProperNounIdentifier)
    @ignore = ['Deputy','Managing','Director','Chairman','Director,','(Registered']
  end

  describe 'when asked to identify proper nouns' do
    it 'should find em' do
      text = 'Managing Director and controlling interest in Mowthorpe (UK) Ltd; the company operates a green/woodland cemetery on land which was previously part of Southwood Farm, Terrington, in NorthYorkshire.'
      nouns = PNI.proper_nouns(text, :ignore=>@ignore)
      nouns[0].should == 'Mowthorpe (UK) Ltd'
      nouns[1].should == 'Southwood Farm, Terrington'
      nouns[2].should == 'NorthYorkshire'
    end

    it 'should find all' do
      text = 'Director, International School for Security and Explosives Education (ISSEE) (non-executive).'
      nouns = PNI.proper_nouns(text, :ignore=>@ignore)
      nouns[0].should == 'International School for Security and Explosives Education (ISSEE)'
    end

    it 'should spot all' do
      text = 'Since May 1997, occasional briefing and visits to the House in connection with particular legislation by Mr Simon Calvert, Deputy Director of the Christian Institute.'
      nouns = PNI.proper_nouns(text, :ignore=>@ignore)
      nouns[0].should == 'Since May'
      nouns[1].should == 'House'
      nouns[2].should == 'Mr Simon Calvert'
      nouns[3].should == 'Christian Institute'
    end

    it 'should do this' do
      text = 'A member of staff is seconded by KPMG to work in the Policy Unit of the Conservative Party, working to the Director of Policy and Research; I am Chairman of the Policy Review'
      nouns = PNI.proper_nouns(text, :ignore=>@ignore)
      nouns[0].should == 'KPMG'
      nouns[1].should == 'Policy Unit'
      nouns[2].should == 'Conservative Party'
      nouns[3].should == 'Policy and Research'
      nouns[4].should == 'Policy Review'
    end

    it 'should include numbers' do
      text = 'I was the guest of Mr Richard Phillips, Managing Director of Silverstone Circuits Limited at the Formula 1 British Grand Prix on 6 July 2008. (Registered 22 July 2008)'
      nouns = PNI.proper_nouns(text, :ignore=>@ignore)
      nouns[0].should == 'Mr Richard Phillips'
      nouns[1].should == 'Silverstone Circuits Limited'
      nouns[2].should == 'Formula 1 British Grand Prix'
      nouns[3].should == '6 July 2008'
      nouns[4].should == '22 July 2008'
    end
  end
end
