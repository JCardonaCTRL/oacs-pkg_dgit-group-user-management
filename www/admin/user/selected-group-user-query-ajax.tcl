#/packages/group-user-management/www/user/selected-group-user-query-ajax.tcl
ad_page_contract {
    Query user in local group info

    @author weixiayu@mednet.ucla.edu
    @creation-date: 2020-05-14
} {
    {user_id:integer,notnull}
    {group_id:integer,notnull}
}

set json_record_list [list]
db_1row select_user "" -column_array row

set user_name $row(username)
set user_last_name $row(last_name)
set user_first_names $row(first_names)
set screen_name $row(screen_name)

set rel_type [db_string select_rel_type "" -default ""]
switch $rel_type {
    "auto_membership_rel" {
        set mode "Automatically"
    }
    "manual_membership_rel" {
        set mode "Manually"
    }
    "exclusion_membership_rel" {
        set mode "Exclusion"
    }
    default {
        set mode ""
    }
}
set info_list [list [list user_last_name $user_last_name] \
                    [list user_first_names $user_first_names] \
                    [list user_name $user_name] \
                    [list screen_name $screen_name] \
                    [list mode $mode]]
set json_record "{[ctrl::json::construct_record $info_list]}"
lappend json_record_list $json_record


doc_return 200 application/json "\[[join $json_record_list  ", "]\]"
