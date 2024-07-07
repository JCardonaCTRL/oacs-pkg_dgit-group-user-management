<?xml version="1.0"?>
<queryset>
   <fullquery name="dap::group::get_group_options.get">
      <querytext>
            select group_name, group_id from dgit_dgsom_app_groups
      </querytext>
    </fullquery>

   <fullquery name="dap::group::new.dgsom_app_group">
      <querytext>
            select group_user_management__new_group (null,
                                   :group_code,
                                   :group_name,
                                   null,
                                   null,
                                   null,
                                   null,
                                   null,
                                   null,
                                   null,
                                   null,
                                   null,
                                   :group_type,
                                   null,
                                   null,
                                   null,
                                   null,
                                   null );
      </querytext>
    </fullquery>

   <fullquery name="dap::group::new.insert_ou_group">
      <querytext>
            insert into ou_groups_mapping
            values (:group_id, :category_id)
      </querytext>
    </fullquery>

    <fullquery name="dap::group::get_rel_id.select">
        <querytext>
            select rel_id
            from acs_rels
            where object_id_one = :group_id and
                  object_id_two = :user_id
        </querytext>
    </fullquery>

   <fullquery name="dap::group::edit.update_group_name">
      <querytext>
            update groups
            set group_name = :group_name
            where group_id = :group_id
      </querytext>
   </fullquery>

   <fullquery name="dap::group::edit.update_group_code">
      <querytext>
            update dgsom_app_ext
            set group_code = :group_code
            where group_id = :group_id
      </querytext>
   </fullquery>

   <fullquery name="dap::group::edit.delete_ou_group">
      <querytext>
            delete from ou_groups_mapping
            where group_id    = :group_id and
                  category_id = :category_id
      </querytext>
    </fullquery>

   <fullquery name="dap::group::edit.insert_ou_group">
      <querytext>
            insert into ou_groups_mapping
            values (:group_id, :category_id)
      </querytext>
    </fullquery>

    <fullquery name="dap::group::get.get_group_info">
      <querytext>
            select g.group_id, g.group_name, ogm.category_id
            from groups g
            left join ou_groups_mapping ogm on g.group_id = ogm.group_id
            where g.group_id = :group_id
      </querytext>
    </fullquery>
    <fullquery name="dap::group::edit.get_assigned_ou_groups">
        <querytext>
            select category_id
            from ou_groups_mapping
            where group_id = :group_id
        </querytext>
    </fullquery>
    <fullquery name="dap::group::edit.get_group_name">
        <querytext>
            select group_name
            from groups
            where group_id = :group_id
        </querytext>
    </fullquery>
    <fullquery name="dap::group::get_code.select">
        <querytext>
            select group_code from dgsom_app_ext
            where group_id = :group_id
        </querytext>
    </fullquery>

    <fullquery name="dap::group::add_user_automatically.query_group_from_mapping">
        <querytext>
            select group_id
            from ou_groups_mapping
            where category_id = :category_id
        </querytext>
    </fullquery>

    <fullquery name="dap::group::add_user_automatically.select_rel_type">
        <querytext>
            select rel_type
            from acs_rels
            where object_id_one = :group_id and
                  object_id_two = :user_id
        </querytext>
    </fullquery>

    <fullquery name="dap::group::add_user_automatically.query_group_from_user">
        <querytext>
            select rels.object_id_one as group_id
            from acs_rels               rels
	    join dgit_dgsom_app_groups  dag on rels.object_id_one = dag.group_id
            where rels.object_id_two = :user_id
            and rels.rel_type        = 'auto_membership_rel'
        </querytext>
    </fullquery>

    <fullquery name="dap::group::add_user_automatically.query_category_from_mapping">
        <querytext>
            select category_id
            from ou_groups_mapping
            where group_id = :group_id
        </querytext>
    </fullquery>
</queryset>
