#/packages/group-user-management/www/user/user-assign-group-ae.tcl
ad_page_contract {
    User Group Assignment

    @author: weixiayu@mednet.ucla.edu
    @creation-date: 2020-06-03
} {
    {user_id:integer,optional}
    {group_id:integer,notnull}
    {mode "Manully"}
}

## -------------------------------------------------------------------------------
## Permission
## -------------------------------------------------------------------------------
set login_user_id   [auth::require_login]
set package_id      [ad_conn package_id]
set package_url     [ad_conn package_url]
## ------------------------------------------------------------------------------
## Initial settings
## ------------------------------------------------------------------------------
if [exists_and_not_null user_id] {
    set rel_list [party::approved_members -party_id $user_id -object_type "dgsom_app"]
}
set return_url "${package_url}admin/group/group-detail?group_id=$group_id"
set group_options [dap::group::get_group_options]
set mode_options [list [list Manually manual_membership_rel] [list Exclusion exclusion_membership_rel]]
ad_form -name group_user_group_ae  \
    -export {return_url group_id} -cancel_url $return_url -form {
    {user_id:key}
    {mode:text(radio),optional {label "Mode:"} {options $mode_options}}
    {ok_btn:text(submit) {label "Submit"}}
} -edit_request {
} -on_submit {
} -new_data {
} -edit_data {
    set success_p [dap::group::add_user -group_id $group_id  -user_id $user_id -mode $mode]
    if $success_p {
        set display_message "The user has been assigned the group successfully."
    } else {
        set display_message "There is an error occured during assigning the user into the group."
    }
} -after_submit {
    ad_returnredirect -message $display_message "$return_url"
    ad_script_abort
}
