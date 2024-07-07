#/packages/group-user-management/www/index.tcl
ad_page_contract {
    Group User Management Main Page

    @author: weixiayu@mednet.ucla.edu
    @creation-date: 2020-05-13
} {
   
}

## -------------------------------------------------------------------------------
##   Permission
## -------------------------------------------------------------------------------
set login_user_id   [auth::require_login]
set package_id      [ad_conn package_id]
set package_url     [ad_conn package_url]

permission::require_permission -party_id $login_user_id -object_id $package_id  -privilege admin

util_get_user_messages -multirow user_messages

set return_url [ad_return_url]
set group_list_ajax_url "${package_url}admin/group/group-list-ajax"

set selected_user_ajax_query_url "${package_url}admin/user/selected-user-query-ajax";#Search User
set user_ajax_query_url "${package_url}admin/user/user-query-ajax" ;#Search User
set group_ajax_query_url "${package_url}admin/group/group-query-ajax";#get group info


template::head::add_css -href "//cdn.datatables.net/2.0.3/css/dataTables.dataTables.min.css" -order 99
template::head::add_javascript -src "//cdn.datatables.net/2.0.3/js/dataTables.min.js" -order 99

security::csp::require script-src cdn.datatables.net
security::csp::require style-src cdn.datatables.net
