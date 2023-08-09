/* $(document).ready(function () {
    $('label.tree-toggler').click(function () {
        $(this).parent().children('ul.tree').toggle(300);
    });
}); */
/* 
const toggler = document.querySelector(".btn");
toggler.addEventListener("click",function(){
	document.querySelector("#sidebar").classList.toggle("collapsed");
});

$(document).ready(function() {
	$('.docs_link').on('click', function(event) {
		event.preventDefault(); 
		// Load the file
		$('.container-fluid').load($(this).attr('href'), function(response, status, xhr) {
			if (status == "error") {
				console.error("There was an error loading the file: " + xhr.status + " " + xhr.statusText);
			}
		});
	});
	// Set up a MutationObserver
    var observer = new MutationObserver(function(mutationsList, observer) {
        // If anything changes in the '.container-fluid' element, update the ToC
        updateToC();
    });
	// Start observing the '.cont' element for changes
    observer.observe($('.cont')[0], { childList: true, subtree: true });
});
 */

/* 
$(document).ready(function() {
    // On button click, load content and update ToC
    $("#loadContent").click(function() {
        // Replace this with your content loading code
        $("#content").html(`
            <section id="section1">
                <h6>Section 1</h6>
                <p>Some content for section 1...</p>
            </section>
            <section id="section2">
                <h6>Section 2</h6>
                <p>Some content for section 2...</p>
            </section>
        `);
        
        // Update ToC
        updateToC();
    });
}); */
/* 
// Function to generate the ToC
function updateToC() {
	console.log("Update toc");
    // Clear the current ToC
    $("#toc").empty();
    
    // Generate the new ToC
    $(".cont h1").each(function() {
        var id = $(this).parent().attr('id');
        var title = $(this).text();
        $("#toc").append('<li><a href="#' + id + '">' + title + '</a></li>');
    });
} */


/* 
$(document).ready(function() {
    $("h6").each(function() {
        var id = $(this).parent().attr('id');
        var title = $(this).text();
        $("#navigation").append('<li><a href="#' + id + '">' + title + '</a></li>');
    });
});
 */