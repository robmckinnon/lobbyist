module OrganisationsHelper

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
