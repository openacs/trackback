-- trackback 
-- Dave Bauer dave@thedesignexperience.org
-- 2003-04-17

-- table to extend general comments to record
-- trackback specific information

create table trackback_pings (
 	tb_url	varchar(1000),
	name	varchar(1000),
	comment_id	integer
			constraint
			tb_pings_comment_id_fk 
			references general_comments
);

create index tbp_comment_id_fk_idx on trackback_pings(comment_id);
	
