-- trackback 
-- Dave Bauer dave@thedesignexperience.org
-- 2003-09-29

-- loop through all trackbacked comments

delete from general_comments gc where exists
	(select 1 from trackback_pings tb 
	where tb.comment_id=gc.comment_id);

begin
for v_row in select comment_id from trackback_pings
    acs_message.delete(v_row.comment_id);
loop;
end;
/
show errors

drop table trackback_pings;
 