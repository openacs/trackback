ad_library {
    Automated tests.

    @author Simon Carstensen
    @creation-date 11 November 2003
    @cvs-id $Id$
}

aa_register_case trackback_new {
    Test the trackback::new proc.
} {

    aa_run_with_teardown \
        -rollback \
        -test_code {

            set tb_url "http://foobar.com"
            set object_id [ad_conn path_info]
            set comment_id [db_nextval acs_object_id_seq]

            # Add trackback
            trackback::new \
                -tb_url $tb_url \
                -blog_name "Foo" \
                -object_id $object_id \
                -comment_id $comment_id \
                -user_id [ad_conn user_id] \
                -creation_ip [ad_conn peeraddr] \
                -content "Foo" \
                -comment_mime_type "text/plain" \
                -is_live f \
                -title "Foo" \
                -context_id $object_id

            set success_p [db_string success_p {
                select 1 from trackback_pings where tb_url = :tb_url
            } -default "0"]

            aa_equals "trackback was added successfully" $success_p 1
        }
}
