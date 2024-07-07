<?xml version="1.0"?>
<queryset>
    <fullquery name="selected_rows_to_display">
        <querytext>
            select x1.*
            from (
                select  ROW_NUMBER() OVER () as rn, x2.*
                from (
                    select a.group_id, a.group_name, count(c.object_id_two) as num_of_users 
                    from dgit_dgsom_app_groups a join acs_objects b on a.group_id = b.object_id
                    left join acs_rels c on a.group_id = c.object_id_one  
                    group by a.group_id, a.group_name, b.object_type 
                    $sql_search_filter
                    $sql_order
                ) x2
            ) x1
            $sql_filter_row
        </querytext>
    </fullquery>

    <fullquery name="total_selected_rows">
        <querytext>
            select count(*) from dgit_dgsom_app_groups
            $sql_search_filter
        </querytext>
    </fullquery>

    <fullquery name="total_rows">
        <querytext>
            select count(*) from dgit_dgsom_app_groups
        </querytext>
    </fullquery>

    <fullquery name="query_num_of_automatic">
        <querytext>
            select count(*) from acs_rels where object_id_one = :group_id and 
                rel_type = 'auto_membership_rel'
        </querytext>
    </fullquery>

    <fullquery name="query_num_of_manual">
        <querytext>
            select count(*) from acs_rels where object_id_one = :group_id and
                rel_type = 'manual_membership_rel'
        </querytext>
    </fullquery>

    <fullquery name="query_num_of_exclusion">
        <querytext>
            select count(*) from acs_rels where object_id_one = :group_id and
                rel_type = 'exclusion_membership_rel'
        </querytext>
    </fullquery>
</queryset>
