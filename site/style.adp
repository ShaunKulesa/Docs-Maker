<%
	ns_adp_include ./incl/headstart
	ns_adp_include ./incl/cdn
	ns_adp_include ./incl/custom_css
	ns_adp_include ./incl/headstop
	ns_adp_include ./incl/top_nav
%>

<div class="container">

	<div class="row">
		<div class="col square" id="square1"></div>
		<div class="col square" id="square2"></div>
		<div class="col square" id="square3"></div>
	</div>
	<div class="row">
		<div class="col square" id="square4"></div>
		<div class="col square" id="square5"></div>
		<div class="col square" id="square6"></div>
	</div>

	<img src="data/img/srctree.png" class="img-fluid mx-auto d-block">


	<section id="h">
		<h1>Example Heading 1</h1>
		<h2>Example Heading 2</h2>
		<h3>Example Heading 3</h3>
		<h4>Example Heading 4</h4>
		<h5>Example Heading 5</h5>
		<h6>Example Heading 6</h6>
	</section>

	<section id="fonts">
		<p id="pritext"><b>This paragraph uses --font-primary:</b> Tcl (Tool Command Language) is a very powerful but easy to learn dynamic programming language, suitable for a very wide range of uses, including web and desktop applications, networking, administration, testing and many more. Open source and business-friendly, Tcl is a mature yet evolving language that is truly cross platform, easily deployed and highly extensible.</p>
		<p id="sectext"><b>This paragraph uses --font-secondary:</b> Tk is a graphical user interface toolkit that takes developing desktop applications to a higher level than conventional approaches. Tk is the standard GUI not only for Tcl, but for many other dynamic languages, and can produce rich, native applications that run unchanged across Windows, Mac OS X, Linux and more. </p>
		<p id="tertext"><b>This paragraph uses --font-tertiary:</b> Tcl (Tool Command Language) is a very powerful but easy to learn dynamic programming language, suitable for a very wide range of uses, including web and desktop applications, networking, administration, testing and many more. Open source and business-friendly, Tcl is a mature yet evolving language that is truly cross platform, easily deployed and highly extensible.</p>
		<p id="monotext"><b>This paragraph uses --font-mono:</b> Tk is a graphical user interface toolkit that takes developing desktop applications to a higher level than conventional approaches. Tk is the standard GUI not only for Tcl, but for many other dynamic languages, and can produce rich, native applications that run unchanged across Windows, Mac OS X, Linux and more. </p>
		<p id="condtext"><b>This paragraph uses --font-condensed:</b> Tk is a graphical user interface toolkit that takes developing desktop applications to a higher level than conventional approaches. Tk is the standard GUI not only for Tcl, but for many other dynamic languages, and can produce rich, native applications that run unchanged across Windows, Mac OS X, Linux and more. </p>
	</section>

	<section id="code">
	<h3>Code example</h3>
	<p id="pritext">For code highlight we can use highlight.js, Syntax highlighting for the Web: </p>
<div class="code-container">
    <button class="btn btn-sm btn-outline-success copy-button"><i class="bi bi-clipboard"></i></button>
	<pre>
	<code class="language-tcl">
	# Some comment in here
	proc apply {fun args} {
		set len [llength $fun]
		if {($len < 2) || ($len > 3)} {
			 error "can't interpret \"$fun\" as anonymous function"
		}
		lassign $fun argList body ns
		set name ::$ns::[getGloballyUniqueName]
		set body0 {
			 rename [lindex [info level 0] 0] {}
		}
		proc $name $argList ${body0}$body
		set code [catch {uplevel 1 $name $args} res opt]
		return -options $opt $res
	}

	</code>
	</pre>
</div>
	</section>

	<section id="list">
		<div class="row">
			<h3>Lists</h3>
		</div>
		<div class="row">
			<div class="col-6">
				<h4>UL List</h4>
				<p>The TCT currently contains the following members:</p>
				<ul>
					<li>Mo DeJong</li>
					<li>Jos Decoster</li>
					<li>Donal Fellows</li>
					<li>Alexandre Ferrieux</li>
					<li>Brian Griffin</li>
					<li>Jeffrey Hobbs</li>
					<li>Kevin Kenny</li>
					<li>Andreas Kupries</li>
					<li>Steve Landers</li>
					<li>Jan Nijtmans</li>
					<li>Don Porter</li>
					<li>Francois Vogel</li>
					<li>Kevin Walzer</li>
					<li>Marc Culler</li>
				</ul>
			</div>
			<div class="col">
				<h4>OL List</h4>
				<p>The TCT currently contains the following members:</p>
				<ol>
					<li>Mo DeJong</li>
					<li>Jos Decoster</li>
					<li>Donal Fellows</li>
					<li>Alexandre Ferrieux</li>
					<li>Brian Griffin</li>
					<li>Jeffrey Hobbs</li>
					<li>Kevin Kenny</li>
					<ol>
						<li>Andreas Kupries</li>
						<li>Steve Landers</li>
						<li>Jan Nijtmans</li>
					</ol>
					<li>Andreas Kupries</li>
					<li>Steve Landers</li>
					<li>Jan Nijtmans</li>
					<li>Don Porter</li>
					<li>Francois Vogel</li>
					<li>Kevin Walzer</li>
					<li>Marc Culler</li>
				</ol>
			</div>
		</div>

	</section>

    <section id="contact">
      <h3>Contact</h3>
      <p>This is the contact section of my website. It contains information on how to get in touch with me.</p>
    </section>



	<img src="./data/img/new_logo1.svg" width="80">
	<% 
		ns_adp_include ./dev_notes/why_programming_languages_sites_are_blue.txt
	%>



<div class="code-container">
    <button class="btn btn-sm btn-outline-success copy-button"><i class="bi bi-clipboard"></i></button>
	<pre>
	<code class="language-tcl">
	# Some comment in here
	proc apply {fun args} {
		set len [llength $fun]
		if {($len < 2) || ($len > 3)} {
			 error "can't interpret \"$fun\" as anonymous function"
		}
		lassign $fun argList body ns
		set name ::$ns::[getGloballyUniqueName]
		set body0 {
			 rename [lindex [info level 0] 0] {}
		}
		proc $name $argList ${body0}$body
		set code [catch {uplevel 1 $name $args} res opt]
		return -options $opt $res
	}

	</code>
	</pre>
</div>




</div>

<%
	ns_adp_include ./incl/footer
	ns_adp_include ./incl/custom_js
	ns_adp_puts "</body>"
	ns_adp_puts "</html>"
%>