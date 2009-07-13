module OrganisationsHelper

  def link_to_periods register_entries
    periods = register_entries.collect do |entry|
      period_start = entry.data_source.period_start
      period_end = entry.data_source.period_end
      same_year = period_start.year == period_end.year
      label = same_year ? period_start.to_s(:mmm_year)[0..2] : period_start.to_s(:mmm_year)
      label += "-#{period_end.to_s(:mmm_year)}"
      link_to label, register_entry_url(entry)
    end
    "(#{periods.join(', ')})"
  end
  
  def search_script element_id, name
%Q|<script src="http://www.google.com/jsapi" type="text/javascript"></script>
  <script language="Javascript" type="text/javascript">
  google.load('search', '1');
  function OnLoad() {
    var searchControl = new google.search.SearchControl();
    var localSearch = new google.search.WebSearch();
    searchControl.addSearcher(localSearch);
    searchControl.draw(document.getElementById("#{element_id}"));
    searchControl.execute("#{name} site:wikipedia.org");
  }
  google.setOnLoadCallback(OnLoad);
</script>|
  end
end
