# /packages/lars-blogger/www/trackback-chunk.tcl
# generates rdf fragment to indentify trackback URL for a weblog entry
# @param url url of object to trackback (relative to page root)
# @param object_id entry_id of entry
# @param title title of entry

set base_url [ad_url]
set trackback_url [trackback::object_url -object_id $object_id]