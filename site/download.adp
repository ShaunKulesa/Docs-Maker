<%
	ns_adp_include ./incl/headstart
	ns_adp_include ./incl/cdn
	ns_adp_include ./incl/custom_css
	ns_adp_include ./incl/headstop
	ns_adp_include ./incl/top_nav
%>

<div class="container">
	<div class="row">
		<p>There are several options available for obtaining Tcl/Tk. If you on Linux or Mac, there is a chance that Tcl/Tk is already installed as Operating System Package. To check the version installed, start Tcl/Tk (usually via running "tclsh" or "wish" from a command line), and typing:</p>
		<div class="code-container">
			<button class="btn btn-sm btn-outline-success copy-button"><i class="bi bi-clipboard"></i></button>
<pre>
<code class="language-tcl">
info patchlevel

</code>
</pre>
		</div>
	</div>
	<div class="row">
		<div class="col"></div>
		<div class="col"></div>
	</div>


	<div class="row">
		<p>The main site for Tcl/Tk source distributions is <a href="https://sourceforge.net/projects/tcl">SourceForge</a>, official mirror on <a href="https://github.com/tcltk/tcl">GitHub</a>. The latest downloads for the Tcl 8.6 and 8.7 release sequences are shown in the table below. Older releases are also available from the above sites. </p>
		<div class="col">
			<h4>Tcl 8.6.13 Sources (Stable)</h4>
			<table class="table">
				<tbody>
					<tr>
						<td><a href="http://prdownloads.sourceforge.net/tcl/tcl8.6.13-src.tar.gz">tcl8.6.13-src.tar.gz</a></td>
						<td>Gzip format</td>
					</tr>
					<tr>
						<td><a href="http://prdownloads.sourceforge.net/tcl/tcl8613-src.zip">tcl8613-src.zip</a></td>
						<td>Zip format</td>
					</tr>
				</tbody>
			</table>
		</div>
		<div class="col">
			<h4>Tk 8.6.13 Sources (Stable)</h4>
			<table class="table">
				<tbody>
					<tr>
						<td><a href="http://prdownloads.sourceforge.net/tcl/tk8.6.13-src.tar.gz">tk8.6.13-src.tar.gz</a></td>
						<td>Gzip format</td>
					</tr>
					<tr>
						<td><a href="http://prdownloads.sourceforge.net/tcl/tk8613-src.zip">tk8613-src.zip</a></td>
						<td>Zip format</td>
					</tr>
				</tbody>
			</table>
		</div>
	</div>

	<div class="row">
		<div class="col">
			<h4>Tcl 8.7a5 Sources (Development)</h4>
			<table class="table">
				<tbody>
					<tr>
						<td><a href="http://prdownloads.sourceforge.net/tcl/tcl8.7a5-src.tar.gz">tcl8.7a5-src.tar.gz</a></td>
						<td>Gzip format</td>
					</tr>
					<tr>
						<td><a href="http://prdownloads.sourceforge.net/tcl/tcl87a5-src.zip">tcl87a5-src.zip</a></td>
						<td>Zip format</td>
					</tr>
				</tbody>
			</table>
		</div>
		<div class="col">
			<h4>Tk 8.7a5 Sources (Development)</h4>
			<table class="table">
				<tbody>
					<tr>
						<td><a href="http://prdownloads.sourceforge.net/tcl/tk8.7a5-src.tar.gz">tk8.7a5-src.tar.gz</a></td>
						<td>Gzip format</td>
					</tr>
					<tr>
						<td><a href="http://prdownloads.sourceforge.net/tcl/tk87a5-src.zip">tk87a5-src.zip</a></td>
						<td>Zip format</td>
					</tr>
				</tbody>
			</table>
		</div>
	</div>
	
	<div class="row">
		<div class="col">
			<p> The source releases include make files for Windows, Unix and Xcode project files for Mac OS X. Once you've retrieved the sources, see <a href="compile.adp">How to Compile Tcl Source Releases</a>.</p>
		</div>
	</div>

<section id="home">
      <h6>Home</h6>
      <p> Tcl (Tool Command Language) is a very powerful but easy to learn dynamic programming language, suitable for a very wide range of uses, including web and desktop applications, networking, administration, testing and many more. Open source and business-friendly, Tcl is a mature yet evolving language that is truly cross platform, easily deployed and highly extensible.

Tk is a graphical user interface toolkit that takes developing desktop applications to a higher level than conventional approaches. Tk is the standard GUI not only for Tcl, but for many other dynamic languages, and can produce rich, native applications that run unchanged across Windows, Mac OS X, Linux and more. </p>
    </section>

    <section id="about">
      <h2>About</h2>
      <p>This is the about section of my website. It contains some information about me and the purpose of this website.</p>
    </section>

    <section id="contact">
      <h3>Contact</h3>
      <p>This is the contact section of my website. It contains information on how to get in touch with me.</p>
    </section>

Hello

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