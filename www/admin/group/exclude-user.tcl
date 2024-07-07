#/packages/group-user-management/www/group/exclude-user
ad_page_contract {
    This page is used to remove a user from a group
    @author: weixiayu@mednet.ucla.edu
    @creation-date: 2020-06-02
} {
    {group_id:integer,notnull}
    {user_id:integer,notnull}
    {return_url ""}
}

## ------------------------------------------------------------------------------
##  Permissions settings
## ------------------------------------------------------------------------------
set package_id      [ad_conn package_id]
set login_user_id   [auth::require_login]
set package_url     [ad_conn package_url]
set admin_p [permission::permission_p -object_id $package_id -privilege admin]
if {$return_url eq ""} {
    set return_url "${package_url}admin/group/group-detail?group_id=$group_id"
}
if {$admin_p} {
    set success_p [dap::group::exclude_user -group_id $group_id -user_id $user_id]
    if $success_p {
        set display_message "The user has been exclude successfully."
    } else {
        set display_message "An error occurred during excluding the user."
    }
} else {
    set display_messwage "You don't have the permission to exclude the user."
}
ad_returnredirect -message $display_message $return_url
ad_script_abort

