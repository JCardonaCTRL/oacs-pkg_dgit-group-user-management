#/packages/group-user-management/www/group/group-list-ajax
ad_page_contract {
    This is the ajax DataTable page for group

    @author: weixiayu@mednet.ucla.edu
    @creation-date: 2020-05-13
} {
}
## -------------------------------------------------------------------------------
##   Permissions settings
## -------------------------------------------------------------------------------
set login_user_id   [auth::require_login]
set package_id      [ad_conn package_id]
set package_url     [ad_conn package_url]
set admin_p         [permission::permission_p -object_id $package_id -privilege admin]
## ------------------------------------------------------------------------------
## Initial settings
## ------------------------------------------------------------------------------
ctrl::jquery::datatable::query_param

set sql_order ""
set sql_order_list ""
foreach {col dir} $dt_info(sort_list) {
    lappend sql_order_list "$col $dir"
}

if ![empty_string_p $sql_order_list] {
    set sql_order " order by [join $sql_order_list ","]"
}

# ---------------------------------------------
# Add filter for the numbmer of rows to display
# ----------------------------------------------
array set dt_page_info $dt_info(page_attribute_list)
set sql_filter_row "where rn > $dt_page_info(start) and rn <= [expr $dt_page_info(start)+$dt_page_info(length)]"

# ---------------------------------------------
# Set search up
# ---------------------------------------------
set search_value ""
if ![empty_string_p $dt_info(search_global)] {
    array set search_arr $dt_info(search_global)
    set search_value $search_arr(value)
}

# -----------------------------------------------
# Generate the records to return
# -----------------------------------------------
set sql_search_list  [list]
set sql_search_filter ""
set field_list [list group_name]
foreach field_name $field_list {
    if {![empty_string_p $search_value]} {
        lappend sql_search_list "lower($field_name) like '%'||lower(:search_value)||'%'"
    }
}

if {[llength $sql_search_list] > 0} {
    set sql_search_filter " and  ([join $sql_search_list " or "])"
}

set data_json_list ""
set field_list [list]
set actions ""

foreach {index column_info} $dt_info(column_info_list) {
    array set column_arr_$index $column_info
    lappend field_list [set column_arr_${index}(data)]
}
set row_num 0
db_foreach selected_rows_to_display "" {
    incr row_num
    set field_json [list]
    foreach fs_field $field_list {
        if [empty_string_p $fs_field] {
            continue
        }
        if {$fs_field eq "group_name"} {
            set new_value "<a href='group/group-detail?[export_vars {group_id}]'>$group_name</a>"
            lappend field_json [ctrl::json::construct_record  [list [list $fs_field $new_value]]]
        } elseif {$fs_field eq "num_of_automatic"} {
            set num_of_automatic [db_string query_num_of_automatic "" -default 0]
            lappend field_json [ctrl::json::construct_record  [list [list $fs_field $num_of_automatic]]]
        } elseif {$fs_field eq "num_of_manual"} {
            set num_of_manual [db_string query_num_of_manual "" -default 0]
            lappend field_json [ctrl::json::construct_record  [list [list $fs_field $num_of_manual]]]
        } elseif {$fs_field eq "num_of_exclusion"} {
            set num_of_exclusion [db_string query_num_of_exclusion "" -default 0]
            lappend field_json [ctrl::json::construct_record  [list [list "num_of_exclusion" $num_of_exclusion]]]
        } else {
            set $fs_field [ctrl::json::filter_special_chars_dt [set $fs_field]]
            set new_value [set $fs_field]
            set new_value [regsub -all "\r" $new_value " "]
            lappend field_json [ctrl::json::construct_record  [list [list $fs_field $new_value]]]
        }
    }
    set actions ""
    if { $admin_p || $admin_group_p} {
        append actions "<button type='button' class='btn btn-info btn-xs' id='edit-group-button' \
                                    data-bs-toggle='modal' data-bs-target='#group-modal'\
                                    data-toggle='modal' data-target='#group-modal' \
                                    data-group_id='$group_id' data-title='Edit Group $group_name'>Edit</button>"

        append actions "&nbsp;<button type='button' class='btn btn-danger btn-xs' id='delete-group-button' \
                                    data-bs-toggle='modal' data-bs-target='#delete-group-modal' \
                                    data-toggle='modal' data-target='#delete-group-modal' \
                                    data-group_id='$group_id' data-title='Delete Group ($group_name):' \
                                    data-destination='${package_url}admin/group/delete-group?[export_vars {group_id}]'>Delete</button>"
    }
    lappend field_json [ctrl::json::construct_record [list [list "actions" $actions]]]
    lappend data_json_list "{[join $field_json ","]}"
}

set iFilteredTotal [db_string total_selected_rows ""]
set iTotal         [db_string total_rows ""]

set result  [ctrl::json::construct_record \
                [list \
                    [list draw              $dt_page_info(draw) i] \
                    [list recordsTotal      $iTotal] \
                    [list recordsFiltered   $iFilteredTotal] \
                    [list data              [join $data_json_list ","] a-joined] \
                ] \
            ]
doc_return 200 application/json "{$result}"
