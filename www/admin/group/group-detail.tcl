#/packages/group-user-management/www/group/group-detail
ad_page_contract {
    This is the group detail page 

    @author: weixiayu@mednet.ucla.edu
    @creation-date: 2020-06-01
} {
    {group_id:integer,notnull}
    {mode "all"}
}

## -------------------------------------------------------------------------------
##   Permission
## -------------------------------------------------------------------------------
set login_user_id   [auth::require_login]
set package_id      [ad_conn package_id]
set package_url     [ad_conn package_url]
set return_url      [ad_return_url]

permission::require_permission -party_id $login_user_id -object_id $package_id  -privilege admin

util_get_user_messages -multirow user_messages

set group_name [db_exec_plsql get_group_name "select acs_group__name($group_id)"]
set back_url                            "${package_url}admin/"
set selected_group_user_ajax_query_url  "${package_url}admin/user/selected-group-user-query-ajax"
set user_list_ajax_url                  "${package_url}admin/user/user-list-ajax?group_id=$group_id"
set user_ajax_query_url                 "${package_url}admin/user/user-query-ajax" ;#Search User


template::head::add_css -href "//cdn.datatables.net/2.0.3/css/dataTables.dataTables.min.css" -order 99
template::head::add_javascript -src "//cdn.datatables.net/2.0.3/js/dataTables.min.js" -order 99

security::csp::require script-src cdn.datatables.net
security::csp::require style-src cdn.datatables.net