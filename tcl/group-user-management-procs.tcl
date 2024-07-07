ad_library {
    Set of TCL procedures to handle groups and users

    @author: weixiayu@mednet.ucla.edu
    @creation-date: 2020-05-19
}

namespace eval dap::group {}

ad_proc -public dap::group::get_group_options {
} {
    Return a list of lists with group_name and group_id
} {
    return [db_list_of_lists get ""]
}

ad_proc -public dap::group::add_user {
    {-group_id:required}
    {-user_id:required}
    {-mode:required}
} {
    Add a user into a group
} {
    set rel_id [dap::group::get_rel_id -group_id $group_id -user_id $user_id]
    set exist_p 0
    if { $rel_id ne ""} {
        set exist_p 1
    }
    set success_p 0
    if !$exist_p {
    set new_rel_id [relation_add -member_state "approved" $mode $group_id $user_id]
        set success_p 1
    }
    return $success_p
}

ad_proc -public dap::group::get_rel_id {
    {-group_id:required}
    {-user_id:required}
} {
    Get rel_id for a specific group and user
} {
    set rel_id [db_string "select" "" -default ""]
    return $rel_id
}

ad_proc -public dap::group::include_user {
    {-group_id:required}
    {-user_id:required}
} {
    Include a user into a group
} {
    set success_p 0
    set mode "manual_membership_rel"
    set rel_id [dap::group::get_rel_id -group_id $group_id -user_id $user_id]
    if { $rel_id ne ""} {
        relation_remove $rel_id
        relation_add -member_state "approved" $mode $group_id $user_id
        set success_p 1
    }
    return $success_p
}

ad_proc -public dap::group::exclude_user {
    {-group_id:required}
    {-user_id:required}
} {
    Remove a user from a group
} {
    set success_p 0
    set mode "exclusion_membership_rel"
    set rel_id [dap::group::get_rel_id -group_id $group_id -user_id $user_id]
    if { $rel_id ne ""} {
        relation_remove $rel_id
        relation_add -member_state "approved" $mode $group_id $user_id
        set success_p 1
    }
    return $success_p
}

ad_proc -public dap::group::remove_user {
    {-group_id:required}
    {-user_id:required}
} {
    Remove a user from a group
} {
    set success_p 0
    set rel_id [dap::group::get_rel_id -group_id $group_id -user_id $user_id]
    if { $rel_id ne ""} {
        relation_remove $rel_id
        set success_p 1
    }
    return $success_p
}

ad_proc -public dap::group::new {
   {-group_name:required}
   {-group_code:required}
   {-ou_groups ""}
   {-group_type "dgsom_app"}
   {-package_id ""}
} {
    Creates a new group
    If this procedure succeeds, returns the new group_id.  Otherwise, returns 0.
} {
    set group_id_exists [group::get_id -group_name $group_name]
    set exist_p 0
    if { $group_id_exists ne ""} {
        set exist_p 1
    }

    if !$exist_p {
	db_transaction {
            #set group_id [group::new -group_name $group_name -context_id $package_id $group_type]
	    set group_id [db_exec_plsql dgsom_app_group {}]
	    relation_add -member_state membership_rel composition_rel -2 $group_id

	    if {$group_id ne "" && [llength $ou_groups] > 0} {
		foreach category_id $ou_groups {
		    db_dml insert_ou_group {**SQL**}
		}
	    }
	    set error_p 0
    	} on_error {
            ns_log Error "Problem creating a new group: $::errorInfo"
    	    set error_p 1
	}
    	if { $error_p } {
            return 0
    	}
    	return $group_id
    }
}

ad_proc -public dap::group::get_ou_groups {
} {
    Returns a list of lists with ou_group_name
} {
    return [list]
}

ad_proc -public dap::group::get_code {
   {-group_id:required}
} {
   get group_code for given group_id
} {
   return [db_string select "" -default ""]
}

ad_proc -public dap::group::edit {
   {-group_id:required}
   {-group_name:required}
   {-group_code:required}
   {-ou_groups ""}
} {
    Edits an existing group
    If this procedure succeeds, returns the group_id.  Otherwise, returns 0.
} {
    set old_group_name [db_string get_group_name "" -default ""]
    set old_ou_groups [db_list_of_lists get_assigned_ou_groups ""]
    set exist_p 0
    if { $group_name ne $old_group_name} {
    	db_dml update_group_name {**SQL**}
	set error_p 1
    }
    set old_group_code [dap::group::get_code -group_id $group_id]
    if { $old_group_code ne $group_code} {
	db_dml update_group_code {**SQL**}
        set error_p 1
    }
    set success_p 0
    if {[llength $ou_groups] > 0 || [llength $old_ou_groups] > 0} {
    	dap::group::compare_ou_lists $old_ou_groups $ou_groups added_list removed_list
    	if {[llength $added_list] > 0 } {
     	    foreach category_id $added_list {
            	db_dml insert_ou_group {**SQL**}
      	    }
        }
        if {[llength $removed_list] > 0 } {
    	    foreach category_id $removed_list {
	    	db_dml delete_ou_group {**SQL**}
     	    }
        }
    	set success_p 1
    }
    return $success_p
}

ad_proc -public dap::group::compare_ou_lists {
    ori_list new_list added_element_list removed_element_list
} {
    Compare two list to return added and removed element list
    ori_list is already existed list
    new_list is new list
} {
    upvar $added_element_list added_list
    upvar $removed_element_list removed_list
    array unset arr
    set added_list [list]
    set removed_list [list]
    foreach n $ori_list {
        set arr($n) 0
    }
    foreach n $new_list {
        if {[info exists arr($n)]} {
            set arr($n) 1
        } else {
            lappend added_list $n
        }
    }
    foreach n [array names arr] {
        if {$arr($n) == 0} {
            lappend removed_list $n
        }
    }
}

ad_proc -public dap::group::add_user_automatically {
    {-user_id:required}
    {-ou_group_list:required}
} {
    Add a user into local groups automatically which its ou group belongs to
} {
    #################################################
    ## Comment: Check all ou groups of the users
    #################################################
    set ou_category_id_list [list]
    set ou_groups [split $ou_group_list ";"]
    foreach ou_group_name $ou_groups {
        set category_id ""
        if ![empty_string_p $category_id] {
            lappend ou_category_id_list $category_id
            #################################################
            ## Comment: Check groups containing the ou group
            #################################################
            foreach group_id [db_list query_group_from_mapping ""] {
                set rel_type [db_string select_rel_type "" -default ""]
                if [empty_string_p $rel_type] {
                    ##########################################################
                    ## Comment: Assign the user to the group automatically
                    ##########################################################
                    dap::group::add_user -group_id $group_id -user_id $user_id -mode "auto_membership_rel"
                }
            }
        }
    }

    ####################################################################################
    ## Comment: check all groups containing the user where it was added automatically ##
    ####################################################################################
    set group_type_name "dgsom_app"
    foreach group_id [db_list query_group_from_user ""] {
        set exist_p 0
        foreach category_id [db_list_of_lists query_category_from_mapping ""] {
            if {[lsearch $ou_category_id_list $category_id] > -1} {
                set exist_p 1
                break
            }
        }
        if !$exist_p {
            ###########################################################################
            ## user's ou groups never blong to the group, remove user from the group
            ###########################################################################
            dap::group::remove_user -group_id $group_id -user_id $user_id
        }
    }
}
