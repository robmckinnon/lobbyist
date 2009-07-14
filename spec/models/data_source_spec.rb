require File.dirname(__FILE__) + '/../spec_helper'

describe DataSource do

  describe 'when asked to merge adjacent periods' do
    it 'should know when start and end are adjacent' do
      end1   = Date.parse("2009-02-01")
      start2 = Date.parse("2009-03-01")
      DataSource.adjacent?(end1, start2).should be_true
    end

    it 'should return a single period' do
      start1 = Date.parse("2008-12-01")
      end1   = Date.parse("2009-02-01")
      start2 = Date.parse("2009-03-01")
      end2   = Date.parse("2009-05-01")
  
      source1 = mock(DataSource, :period_start => start1, :period_end => end1)
      source2 = mock(DataSource, :period_start => start2, :period_end => end2)
  
      data_sources = [source1, source2]
      DataSource.merge_periods(data_sources).should == [[start1, end2]]
    end
  end

  describe 'when asked to merge non-adjacent periods' do
    it 'should return two periods' do
      start1 = Date.parse("2007-12-01")
      end1   = Date.parse("2008-02-01")
      start2 = Date.parse("2009-03-01")
      end2   = Date.parse("2009-05-01")
  
      source1 = mock(DataSource, :period_start => start1, :period_end => end1)
      source2 = mock(DataSource, :period_start => start2, :period_end => end2)
  
      data_sources = [source1, source2]
      DataSource.merge_periods(data_sources).should == [[start1, end1], [start2, end2]]
    end
  end
end