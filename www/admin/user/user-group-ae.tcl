#/packages/group-user-management/www/user/user-group-ae.tcl
ad_page_contract {
    User Group Assignment

    @author: weixiayu@mednet.ucla.edu
    @creation-date: 2020-05-14
} {
    {user_id:integer,optional}
}

## -------------------------------------------------------------------------------
## Permission
## -------------------------------------------------------------------------------
set login_user_id   [auth::require_login]
set package_id      [ad_conn package_id]

ad_return_template
