#/packages/group-user-management/www/group/delete-group
ad_page_contract {
    This page is used to delete a group
    @author: weixiayu@mednet.ucla.edu
    @creation-date: 2020-06-02
} {
    {group_id:integer,notnull}
    {return_url ""}
}

## ------------------------------------------------------------------------------
##  Permissions settings
## ------------------------------------------------------------------------------

set login_user_id   [auth::require_login]
set package_id      [ad_conn package_id]
set package_url     [ad_conn package_url]
set admin_p [permission::permission_p -object_id $package_id -privilege admin]
if {$return_url eq ""} {
    set return_url "${package_url}admin/"
}
if {$admin_p} {
    if { [catch {application_group::delete -group_id $group_id} result] } {
        set display_message "An error occurred during delete the group."
    } else {    
        set display_message "The group has been deleted successfully."
    } 
} else {
    set display_messwage "You don't have the permission to delete the group."
}
ad_returnredirect -message $display_message $return_url
ad_script_abort

