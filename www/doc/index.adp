
<property name="context">{/doc/trackback {Trackback}} {Trackback Package Documentation for OpenACS}</property>
<property name="doc(title)">Trackback Package Documentation for OpenACS</property>
<master>
<h1>Trackback Package Documentation for OpenACS</h1>
<h2>Background</h2>
<p>This is an implementation of the <a href="http://www.movabletype.org/docs/mttrackback.html">trackback
specification</a> for use in OpenACS.</p>
<p>Trackback is a method of notifying a web site that you have
linked to it. It is most commonly used to link between weblogs. It
allows writers to comment on posts on other web sites from their
own page instead of visiting the other site. Besides this, it
generally allows writers to learn who is reading and commenting on
their posts and helps build community.</p>
<p>A good guide to how it all works is <a href="http://www.movabletype.org/trackback/beginners/" target="new">A
Beginner&#39;s Guide to Trackback (opens in new window)</a> by Mena
and Ben Trott, the original designers of the Trackback
specificaion.</p>
<h3>How it works</h3>
<p>Trackback pings are stored as general-comments. Because
general_comment is not a content repostiory content_type,
trackback is not a separate object_type. This will be fixed in a
future version. Additional information about the weblog that sent
the ping is stored in the trackback_pings table.</p>
<p>Currently any object_id that allows general_comment_create for
the "Unregistered Vistor" user (user_id 0) can receive a
trackback ping. That is the only activity required to allow
trackback to be sent to an object.</p>
<p>A sample implementation is in the lars-blogger package. To
display trackbrack information along with comment information,
include the /packages/trackback/lib/trackback-chunk template in the
page you wish to display comments and trackback pings. The
parameters to the include are:</p>
<pre>
# /packages/lars-blogger/www/trackback-chunk.tcl
# generates rdf fragment to indentify trackback URL for a weblog entry
# \@param url url of object to trackback (relative to page root)
# \@param object_id entry_id of entry
# \@param title title of entry
</pre>
<h2>TODO</h2>
<p>Pending cleanup of general comments to remove dependence on
acs_messaging, trackback_ping should be a subtype of a
general_comment object type.</p>
