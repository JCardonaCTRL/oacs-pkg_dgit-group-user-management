ad_page_contract {
    Search members to add users

    @author weixiayu@mednet.ucla.edu
    @creation-date: 2020-05-14
} {
    {term:optional,trim}
}

set json_record_list [list]

db_foreach find_users {**SQL**} {
    if [empty_string_p $screen_name] {
        set label "$first_names $last_name ($email)"
    } else {
        set label "$first_names $last_name ($email, $screen_name)"
    }
    set value "$user_id"
    set info_list [list [list label $label t] \
    [list value $label t] [list internalValue $value]]

    set json_record "{[ctrl::json::construct_record $info_list]}"
    lappend json_record_list $json_record
}

doc_return 200 application/json "\[[join $json_record_list  ", "]\]"

