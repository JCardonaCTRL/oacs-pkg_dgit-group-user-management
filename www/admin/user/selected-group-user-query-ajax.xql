<?xml version="1.0"?>
<queryset>
    <fullquery name="select_user">
        <querytext>
            select a.username, d.last_name, d.first_names, coalesce(a.screen_name, '') as screen_name
            from users a, persons d
            where a.user_id = :user_id and a.user_id = d.person_id
        </querytext>
    </fullquery>

    <fullquery name="select_rel_type">
        <querytext>
            select rel_type from acs_rels where object_id_one = :group_id and object_id_two = :user_id
        </querytext>
    </fullquery>

    <fullquery name="query_rel_type">
        <querytext>
            select c.group_name, a.rel_type from acs_rels a join acs_objects b on a.object_id_one = b.object_id 
            join dgit_dgsom_app_groups c on a.object_id_one = c.group_id
	        where object_id_two = :user_id
        </querytext>
    </fullquery>

    <fullquery name="query_group_id_list">
        <querytext>
            select object_id_one from acs_rels acr join dgit_dgsom_app_groups dag on acr.object_id_one = dag.group_id
            where object_id_two = :user_id
        </querytext>
    </fullquery>
</queryset>

