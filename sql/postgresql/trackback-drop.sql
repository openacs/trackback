-- trackback 
-- Dave Bauer dave@thedesignexperience.org
-- 2003-09-29

-- loop through all trackbacked comments

delete from general_comments gc where exists
	(select 1 from trackback_pings tb 
	where tb.comment_id=gc.comment_id);

create function inline_0() returns integer as '

declare v_row record;
begin

for v_row in select comment_id from trackback_pings

	perform	acs_message__delete(v_row.comment_id);
loop;

return 0;
end;' language 'plpgsql';

select inline_0();
drop function inline_0();

drop table trackback_pings;
 