-- View: dgsom_app.dgit_dgsom_app_groups

-- DROP VIEW dgsom_app.dgit_dgsom_app_groups;

CREATE OR REPLACE VIEW dgit_dgsom_app_groups
 AS
	select g.*, dag.group_code
	FROM groups g
	JOIN dgsom_app_ext dag
	ON g.group_id = dag.group_id;


