<?xml version="1.0"?>

<queryset>
	
    <fullquery name="trackback::new.add_trackback">
	<querytext>
            insert into trackback_pings
	    (tb_url, comment_id, name)
	    values
	    (:tb_url, :comment_id, :blog_name)
	</querytext>
   </fullquery>

</queryset>