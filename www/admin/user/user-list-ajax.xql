<?xml version="1.0"?>
<queryset>
    <fullquery name="selected_rows_to_display">
        <querytext>
            select x1.*
            from (
                select  ROW_NUMBER() OVER () as rn, x2.*
                from (
                    select a.user_id, a.first_names, a.last_name, a.email, a.screen_name, 
                        b.rel_type, CASE WHEN b.rel_type='manual_membership_rel' THEN 'Manually'
                                         WHEN b.rel_type='auto_membership_rel' THEN 'Automatically'
                                         ELSE 'Exclusion'
                                    END as mode                       
                    from cc_users a join acs_rels b on a.user_id = b.object_id_two 
                    where b.object_id_one = :group_id
                    $mode_filter
                    $sql_search_filter
                    $sql_order
                ) x2
            ) x1
            $sql_filter_row
        </querytext>
    </fullquery>

    <fullquery name="total_selected_rows">
        <querytext>
            select count(*) from  cc_users a join acs_rels b on a.user_id = b.object_id_two
            where b.object_id_one = :group_id                
            $sql_search_filter
        </querytext>
    </fullquery>

    <fullquery name="total_rows">
        <querytext>
            select count(*) from cc_users a join acs_rels b on a.user_id = b.object_id_two
            where b.object_id_one = :group_id
        </querytext>
    </fullquery>
</queryset>
