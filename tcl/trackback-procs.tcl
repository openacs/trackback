#packages/trackback?/tcl/trackback-procs.tcl

ad_library {

}

namespace eval trackback {}

ad_proc -public trackback::new {
    -tb_url
    -blog_name
    -object_id
    -comment_id
    -user_id
    -creation_ip
    -content
    -comment_mime_type
    -is_live
    -title
    -context_id
} {
    add new trackback
} {


       set revision_id [general_comment_new \
		    -object_id $object_id \
		    -comment_id $comment_id \
		    -user_id "" \
		    -creation_ip $creation_ip \
		    -content $content \
		    -comment_mime_type $comment_mime_type \
		    -category "" \
		    -is_live $is_live \
		    -title $title \
		    -context_id $object_id]
       ns_log Debug "Trackback tb_url=$tb_url blog_name=$blog_name"
       db_dml add_trackback ""

    return $comment_id
}


ad_proc -public trackback::package_url {} {
    returns url of mount location for trackback package
} {
    return [apm_package_url_from_key "trackback"]
}

ad_proc -public trackback::object_url { -object_id } {
    returns a fully qualified URL for trackback
} {

    return [trackback::package_url]${object_id}
}


ad_proc -public trackback::auto_ping {
    -url
    -content
    {-blog_name ""}
    {-title ""}
    {-excerpt ""}
} { 
    searches and entry for links and checks them for
    trackback support. If trackback is supported, the parameters are
    user to make a trackback ping.

    http://www.movabletype.org/docs/mttrackback.html

    @param url permanent url of weblog entry
    @param title title of weblog entry
    @param excerpt part of weblog entry
} {

    # loop through links
    # hopefully this will grab anthing starting with http://
    # maybe we need to check other stuff? 
    set links_list [regexp -all -inline {http://[^\"^\s]*} $content]
    ns_log Debug "trackback: List of links $links_list"
    # get trackback url
    foreach link $links_list {
	set result_list [ad_httpget -url $link]
	ns_log debug "trackback: results $result_list"
	array set link_array $result_list
	if {[string equal $link_array(status) 200 ]} {
	    #get trackback_info if available
	    set ping_url_args [trackback::get_ping_url -data $link_array(page) -link $link]
	    set ping_url [lindex $ping_url_args 0]
	    set ping_method [lindex $ping_url_args 1]
	    if {![empty_string_p $ping_url]} {
		trackback::send_ping -ping_url $ping_url \
		                     -excerpt $excerpt \
		                     -url $url \
		                     -title $title \
		                     -blog_name $blog_name \
		                     -method $ping_method
	    }

	}
	
    }

}


ad_proc -public trackback::get_ping_url {
    -data
    -link
} {
    searches for trackback information
    @author Dave Bauer dave@thedesignexperience.org
    @creation-date 2003-04-14
    @param data html content to search
    @param link URL of item linked to, used to find the correct trackback URL if more than one trackback RDF section is in data

@return ping_url URL of trackback link for the content provided or empty string if no trackabck info is found
} {
    set ping_url ""
    set method ""
    foreach rdf_data [regexp -all -inline {<rdf:Description.*?/>} $data] {
	# find dc:identifier tag and compare to link passed in
	# if it matches, look for trackback:ping or fall back to
        # about

	ns_log debug " trackback::get_ping_url rdf_data $rdf_data"
	if {[regexp {trackback:ping=\"([^"]+)\"} $rdf_data extra result]} {
           set ping_url $result
           set method POST
        } elseif {[regexp {about=\"([^"]+)\"} $rdf_data extra result]} {
           set ping_url $result
	   set method GET

        } else {
	    set ping_url "none"
	    set method "none"
	}

    }
    return [list $ping_url $method]
}

ad_proc -public trackback::send_ping {
    -ping_url
    -url
    {-excerpt ""}
    {-title "" }
    {-blog_name ""}
    {-method "POST"}
} {
    sends a trackback ping. returns status code if successful, or error message
    if unsuccessful

    @author Dave Bauer dave@thedesignexperience.org
    @creation-date 2003-04-14
    @param ping_url URL to send ping to
    @param url URL ping is from
    @param excerpt Short text from URL referring to ping_url
    @param title title of URL
} {
    ns_log debug "trackback: ping_url=$ping_url method=$method"

    # POST or GET to trackback ping url

    set query_set [ns_set create]
    ns_set put $query_set url $url
    

    if {[string equal $method GET]} {
	set form_vars [export_vars {url excerpt title blog_name}]
	ns_log debug "trackback: full url = ${ping_url}&${form_vars}"
	# old style GET
	set result [ns_httpget ${ping_url}&${form_vars} 60]
        ns_log debug "trackback: trackback returned: $result"
    } else {
	#must be POST

	set form_vars [export_vars { url }]
	if {![empty_string_p $excerpt]} {
	    ns_set put $query_set excerpt $excerpt
	}
	if {![empty_string_p $title]} {
	    ns_set put $query_set title $title
	}
	if {![empty_string_p $blog_name]} {
	    ns_set put $query_set blog_name $blog_name
	}

	if {[catch {[ns_httppost $ping_url "" $query_set]} result]} {
            ns_log debug "trackback: trackback returned: $result"
	}
    }
    return $result
}
