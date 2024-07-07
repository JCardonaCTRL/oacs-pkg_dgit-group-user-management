<?xml version="1.0"?>
<queryset>
    <fullquery name="get_assigned_ou_groups">
        <querytext>
	    select category_id from ou_groups_mapping
            where group_id = :group_id
        </querytext>
    </fullquery>
    <fullquery name="get_group_name">
        <querytext>
	    select group_name from groups
            where group_id = :group_id
        </querytext>
    </fullquery>
    <fullquery name="get_group_code">
        <querytext>
            select group_code from dgsom_app_ext
            where group_id = :group_id
        </querytext>
    </fullquery>
</queryset>
