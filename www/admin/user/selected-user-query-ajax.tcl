#/packages/group-user-management/www/user/selected-user-query-ajax.tcl
ad_page_contract {
    Query user local group info

    @author weixiayu@mednet.ucla.edu
    @creation-date: 2020-05-14
} {
    {user_id:integer,notnull}
}

set json_record_list [list]
db_1row select_user "" -column_array row

set user_name $row(username)
set user_last_name $row(last_name)
set user_first_names $row(first_names)
set screen_name $row(screen_name)

set group_rel_list [list]
set num 0
db_foreach query_rel_type "" {
    if { $rel_type eq "auto_membership_rel" } {
        set mode "Automatically"
    } elseif { $rel_type eq "manual_membership_rel"} {
        set mode "Manually"
    } else {
        set mode ""
    }

    if ![empty_string_p $mode]  {
        lappend group_rel_list "${group_name}(${mode})"
        incr num
    }
}
set group_rel_arr "[join $group_rel_list ", "]"

set info_list [list [list user_last_name $user_last_name] \
                    [list user_first_names $user_first_names] \
                    [list user_name $user_name] \
                    [list screen_name $screen_name] \
                    [list group_num $num] \
                    [list group_rel_list $group_rel_arr]] 

set json_record "{[ctrl::json::construct_record $info_list]}"
lappend json_record_list $json_record


doc_return 200 application/json "\[[join $json_record_list  ", "]\]"
