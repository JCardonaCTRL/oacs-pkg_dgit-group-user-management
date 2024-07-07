ad_page_contract {
    Query group info

} {
    {group_id ""}
}

set json_record ""

if [exists_and_not_null group_id] {
    # Get DB values
    set group_name [db_string get_group_name "" -default ""]
    set associated_ou_groups [db_list_of_lists get_assigned_ou_groups ""]
    set group_code [db_string get_group_code "" -default ""]

    set info_list [list [list "groupName" $group_name] \
			[list "groupCode" $group_code] \
                        [list "ouGroups" $associated_ou_groups "a"]]

    set info_json "[ctrl::json::construct_record $info_list]"
    set json_record $info_json
}
doc_return 200 application/json "{$json_record}"


