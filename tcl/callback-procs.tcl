ad_library {
    Set of TCL procedures to handle apm callbacks

    @author: jcardona@mednet.ucla.edu
    @creation-date: 2022-11-07
}

namespace eval dap::group::callback {}

ad_proc -public dap::group::callback::after_install {
} {
    Creates the relations needed for the management
} {
    #Validate the dgsom_app group exists, or it will create it
    #also create the group_code column needed
    set object_type         "dgsom_app"
    set safe_object_type    [plsql_utility::generate_oracle_name -max_length 29 $object_type]
    if {![plsql_utility::object_type_exists_p $safe_object_type]} {
        set group_type      [group_type::new -group_type $object_type -supertype "group" "DGSOM APP" "DGSOM APP"]
        set attribute_id    [attribute::add -min_n_values 1 -max_n_values 1 -default "" $object_type "string" "group_code" "group_code"]
        # Recreate all the packages to use the new attribute
        package_recreate_hierarchy $object_type

        db_dml create_view "CREATE OR REPLACE VIEW dgit_dgsom_app_groups
                                AS
                                    select g.*, dag.group_code
                                    FROM groups g
                                    JOIN dgsom_app_ext dag
                                    ON g.group_id = dag.group_id;
                            "

        db_dml create_functions "
            create or replace function group_user_management__new_group(
                integer,
                character varying,
                character varying,
                character varying,
                character varying,
                integer,
                integer,
                integer,
                character varying,
                boolean,
                character varying,
                timestamp with time zone,
                character varying,
                timestamp with time zone,
                integer,
                character varying,
                integer,
                character varying
                ) returns int4 as $$

                DECLARE
                    p_GROUP_ID             alias for \$1;
                    p_GROUP_CODE           alias for \$2;
                    p_GROUP_NAME           alias for \$3;
                    p_URL                  alias for \$4;
                    p_EMAIL                alias for \$5;
                    p_CONTEXT_ID           alias for \$6;
                    p_CREATION_USER        alias for \$7;
                    p_MODIFYING_USER       alias for \$8;
                    p_MODIFYING_IP         alias for \$9;
                    p_SECURITY_INHERIT_P   alias for \$10;
                    p_CREATION_IP          alias for \$11;
                    p_CREATION_DATE        alias for \$12;
                    p_OBJECT_TYPE          alias for \$13;
                    p_LAST_MODIFIED        alias for \$14;
                    p_OBJECT_ID            alias for \$15;
                    p_TITLE                alias for \$16;
                    p_PACKAGE_ID           alias for \$17;
                    p_JOIN_POLICY          alias for \$18;
                    v_GROUP_ID DGSOM_APP_EXT.GROUP_ID%TYPE;
                BEGIN

                    v_GROUP_ID := acs_group__new (
                                    p_group_id,p_OBJECT_TYPE,p_CREATION_DATE,p_CREATION_USER,p_CREATION_IP,p_EMAIL,p_URL,p_GROUP_NAME,p_JOIN_POLICY,p_CONTEXT_ID
                                );

                    insert into DGSOM_APP_EXT 
                        (GROUP_ID, GROUP_CODE) 
                    values 
                        (v_GROUP_ID, p_GROUP_CODE);

                    return v_GROUP_ID;

                END; 
                $$ language plpgsql;

                create or replace function group_user_management__delete_group(
                    p_group_id integer
                ) returns int4 as $$

                DECLARE
                BEGIN

                    perform acs_group__delete( p_GROUP_ID );
                    return 1;

                END;
                $$ language plpgsql;"
    

        rel_types::new \
            -supertype "membership_rel"\
            -role_one "admin" \
            -role_two "member" \
            "auto_membership_rel" \
            "Automatically Membership Relation" \
            "Automatically Membership Relations" \
            dgsom_app \
            0 \
            "" \
            "user" \
            0 \
            ""

        rel_types::new \
            -supertype "membership_rel"\
            -role_one "party" \
            -role_two "member" \
            "manual_membership_rel" \
            "Manually Membership Relation" \
            "Manually Membership Relations" \
            dgsom_app \
            0 \
            "" \
            "user" \
            0 \
            ""

        rel_types::new \
            -supertype "membership_rel"\
            -role_one "party" \
            -role_two "member" \
            "exclusion_membership_rel" \
            "Exclusion Membership Relation" \
            "Exclusion Membership Relations" \
            dgsom_app \
            0 \
            "" \
            "user" \
            0 \
            ""
    }
}

ad_proc -public dap::group::callback::before_uninstall {
} {
    Removes the relations needed for the management
} {
    db_foreach get_groups "select object_id from acs_objects where object_type='dgsom_app'" {
        db_exec_plsql delete_group "select acs_group__delete(:object_id);"
    }
    # db_dml delete_parties "delete from parties where party_id in (select object_id from acs_objects where object_type='dgsom_app');"
    db_dml delete_objects "delete from acs_objects where object_type = 'dgsom_app';"
    db_dml delete_attributes "delete from acs_attributes where object_type = 'dgsom_app';"
    db_dml drop_view "drop view if exists dgit_dgsom_app_groups;"    

    db_exec_plsql delete_rel_types {
        select acs_rel_type__drop_type('auto_membership_rel', 't');
        select acs_rel_type__drop_type('manual_membership_rel', 't');
        select acs_rel_type__drop_type('exclusion_membership_rel', 't');
    }

    group_type::delete -group_type "dgsom_app"
}

