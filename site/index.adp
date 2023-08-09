<%
	ns_adp_include ./incl/headstart
	ns_adp_include ./incl/cdn
	ns_adp_include ./incl/custom_css
	ns_adp_include ./incl/headstop
	ns_adp_include ./incl/top_nav
%>
<div class="container">
	<div class="row">
		<div class="col-8">
			<h5>Welcome to the new Tcl Developer Xchange! TCL DEX!!!</h5>
			<p>Tcl (Tool Command Language) is a very powerful but easy to learn dynamic programming language, suitable for a very wide range of uses, including web and desktop applications, networking, administration, testing and many more. Open source and business-friendly, Tcl is a mature yet evolving language that is truly cross platform, easily deployed and highly extensible.</p>
			<p>Tk is a graphical user interface toolkit that takes developing desktop applications to a higher level than conventional approaches. Tk is the standard GUI not only for Tcl, but for many other dynamic languages, and can produce rich, native applications that run unchanged across Windows, Mac OS X, Linux and more. </p>
		</div>
		<div class="col-4">
			<div class="sidebox">
				<h6>Tcl News</h6>
				<p>
					The 19<sup>th</sup> European OpenACS and Tcl conference takes place in Vienna, on July 20th and 21th.
					Registration is required.
					Please visit the <a href='https://openacs.org/conf2023/info'>main page</a> for the details of registration, accomodation, etc.
				</p>
				<p>
					<a href="/community/conferences.html"> Older conference info </a>
				</p>
			</div>
			<div class="sidebox">
				<h6>Latest Software Releases</h6>
				<p>
					<ul>
						<li>Tcl/Tk 8.6.13 Source</li>
						<li>Tcl/Tk 8.7a5 Pre-release</li>
						<li>All Tcl/Tk Downloads</li>
						<li>ActiveTcl Multi-platform and commercially supported</li>
						<li>BAWT Multi-platform</li>
						<li>Magicsplat Windows</li>
						<li>IronTcl Windows</li>
						<li>Tklib 0.7 Feb 9, 2020</li>
						<li>Tcllib 1.21 May 7, 2022</li>
						<li><a href="https://wiki.tcl-lang.org/page/Category+Distribution">Wiki Category: Distributions</a></li>
					</ul>
				</p>
			</div>
		</div>
	</div>

	<div class="row">
		<div class="col">
			<h6>Core Development</h6>
			<p>A wide variety of developers contribute to the open source Tcl and Tk core, which is hosted at core.tcl-lang.org. The Tcl Core Team (TCT) helps steer this development through mechanisms like Tcl Improvement Proposals (TIP's) and the core mailing list. </p>
			<p>Read More about how the Tcl/Tk core is developed, and how you can help.</p>
		</div>
		<div class="col">
			<h6>Tcl/Tk Community</h6>
			<p>The vibrant Tcl user community provides a variety of support resources to help working with Tcl/Tk. Among others, the Tcler's Wiki provides a constantly updated set of tips and tricks, while comp.lang.tcl remains the best forum for Tcl/Tk discussions. Beyond that we also have IRC, Slack, and Twitter channels. <p>
			<p>Read More about these and other useful community resources.</p>
		</div>
	</div>






</div>
<h3>Code Examples</h3>
<div class="code_examples">
	<!-- Navigation -->
	<ul class="nav nav-tabs tab" id="myTab" role="tablist">
	  <li class="nav-item" role="presentation">
		<a class="nav-link active" id="procedure-tab" data-bs-toggle="tab" href="#procedure" role="tab" aria-controls="procedure" aria-selected="true">Procedure</a>
	  </li>
	  <li class="nav-item" role="presentation">
		<a class="nav-link" id="tcloo-tab" data-bs-toggle="tab" href="#tcloo" role="tab" aria-controls="tcloo" aria-selected="false">Class TclOO</a>
	  </li>
	  <li class="nav-item" role="presentation">
		<a class="nav-link" id="nx-tab" data-bs-toggle="tab" href="#nx" role="tab" aria-controls="nx" aria-selected="false">Class NX</a>
	  </li>
	</ul>
	
	
	<!-- Tab panes -->
<div class="tab-content" id="myTabContent">
  <div class="tab-pane fade show active" id="procedure" role="tabpanel" aria-labelledby="procedure-tab">
<div class="code-container">
    <button class="btn btn-sm btn-outline-primary copy-button"><i class="bi bi-clipboard"></i></button>
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
  <div class="tab-pane fade" id="tcloo" role="tabpanel" aria-labelledby="tcloo-tab">
<div class="code-container">
    <button class="btn btn-sm btn-outline-primary copy-button"><i class="bi bi-clipboard"></i></button>
	<pre>
	<code class="language-tcl">
	package require TclOO;  #if loading for the first time; not required on Tcl 8.6
	oo::class create summation {
		constructor {} {
			variable v 0
		}
		method add x {
			variable v
			incr v $x
		}
		method value {} {
			variable v
			return $v
		}
		destructor {
			variable v
			puts "Ended with value $v"
		}
	}
	set sum [summation new]
	puts "Start with [$sum value]"
	for {set i 1} {$i <= 10} {incr i} {
		puts "Add $i to get [$sum add $i]"
	}
	$sum destroy   ;# only destroy the $sum object. 'summation destroy' destroys ALL summation objects --Duoas

	</code>
	</pre>
</div>
  </div>
  <div class="tab-pane fade" id="nx" role="tabpanel" aria-labelledby="nx-tab">
<div class="code-container">
    <button class="btn btn-sm btn-outline-primary copy-button"><i class="bi bi-clipboard"></i></button>
	<pre>
	<code class="language-tcl">
	package require nx

	nx::Class create Greeter {
		:property name:required
		:public method "say hello" {} {
			puts "Welcome ${:name}!"
		}
		:public method "say bye" {} {
			puts "Goodbye ${:name}!"
		}
	}
	</code>
	</pre>
</div>
  </div>
</div>
	
	
	
	

</div>


<%
	ns_adp_include ./incl/footer
	ns_adp_include ./incl/custom_js
	ns_adp_puts "</body>"
	ns_adp_puts "</html>"
%>