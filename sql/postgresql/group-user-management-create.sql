CREATE TABLE ou_groups_mapping
(
  group_id integer NOT NULL,
  category_id integer NOT NULL,
  PRIMARY KEY (group_id, category_id),
	  CONSTRAINT ou_groups_mapping_group_id_fk FOREIGN KEY (group_id)
      REFERENCES groups (group_id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE CASCADE
);

