ad_page_contract {
    group new/edit form

    @author: rgundu@mednet.ucla.edu
    @creation-date: 2020-06-17
} {
    {group_id:integer,optional}
    {return_url ""}
}

## ------------------------------------------------------------------------------
## Initial settings
## ------------------------------------------------------------------------------
set login_user_id   [auth::require_login]
set package_url     [ad_conn package_url]
set new_form_p 1
set submit_btn_value "Add"

set package_id [ad_conn subsite_id]

set return_url "${package_url}admin/"
if {[ad_form_new_p -key group_id] } {
} else {
    set new_form_p 0
}

set display_msg ""
set ou_groups_list [dap::group::get_ou_groups]
ad_form -name group_ae -export {return_url} -cancel_url $return_url \
    -html {enctype "multipart/form-data"} -form {

    {group_id:key}
    {group_name:text {label "Group Name"} {html {class "name-textbox required"}}}
    {group_code:text {label "Group Code"} {maxlength "100"} {html {class "name-textbox required"}}}
    {ous:text(checkbox),multiple,optional
        {label "OU Groups"}
        {options $ou_groups_list}
	{html {class "ou-groups"}}
    }
    {ok_btn:text(submit) {label $submit_btn_value} {html {class "btn btn-primary" }}}
} -on_submit {
} -new_data {
    set display_msg "Group is created successfully."
    db_transaction {
	dap::group::new -group_name $group_name -group_code $group_code -ou_groups $ous -group_type "dgsom_app" -package_id $package_id
    } on_error {
        set display_msg "An error ocurred while creating group. Please check your data and try again -> $errmsg!" 
    }
} -edit_data {
    set display_msg "Group has been updated successfully."
    db_transaction {
    	dap::group::edit -group_id $group_id -group_name $group_name -group_code $group_code -ou_groups $ous

    } on_error {
        set display_msg "An error ocurred while editing the group. Please check your data and try again -> $errmsg!"
    }
} -after_submit {
    ad_returnredirect -message $display_msg $return_url
    ad_script_abort
}
