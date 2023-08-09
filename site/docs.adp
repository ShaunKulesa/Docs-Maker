<%
	ns_adp_include ./incl/headstart
	ns_adp_include ./incl/cdn
	ns_adp_include ./incl/custom_css
	ns_adp_include ./incl/headstop
	ns_adp_include ./incl/top_nav
%>
<div class="container-fluid">
	<div class="row">
		<div class="col-2">
			<%
				ns_adp_include ./incl/docs_nav
			%>
		</div>
		<div class="col-10" id="docs_cont">
            
        </div>
    </div>
</div>
<script>
	$(function () { $('#docs_nav').jstree({
		"plugins" : [ "wholerow" ]
	  }); });
	$('#docs_nav').on("changed.jstree", function (e, data) {
		console.log(data.selected);
	});



	$('#docs_nav').on('select_node.jstree', function (e, data) {
    var href = data.node.a_attr.href;
    
	if (href) {
			e.preventDefault(); 
			// Load the file
			$('#docs_cont').load(href, function(response, status, xhr) {
				hljs.highlightAll();
				if (status == "error") {
					console.error("There was an error loading the file: " + xhr.status + " " + xhr.statusText);
				}
			});
		}
});

</script>
<%
	ns_adp_include ./incl/footer
	ns_adp_include ./incl/custom_js
	ns_adp_puts "</body>"
	ns_adp_puts "</html>"
%>
