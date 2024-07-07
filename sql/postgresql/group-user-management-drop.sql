drop table if exists ou_groups_mapping;
drop function if exists group_user_management__new_group(
  integer,
  character varying,
  character varying,
  character varying,
  character varying,
  integer,
  integer,
  integer,
  character varying,
  boolean,
  character varying,
  timestamp with time zone,
  character varying,
  timestamp with time zone,
  integer,
  character varying,
  integer,
  character varying
);
drop function if exists group_user_management__delete_group(integer);

drop table if exists auto_membership_rel_ext;
drop table if exists manual_membership_rel_ext;
drop table if exists exclusion_membership_rel_ext;
