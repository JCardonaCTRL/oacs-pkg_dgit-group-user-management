<?xml version="1.0"?>
<queryset>
   <fullquery name="find_users">
      <querytext>
        select user_id, email, first_names, last_name, screen_name
            from cc_users u 
            where ( screen_name is not null and lower(email || ' ' || first_names || ' '||last_name || ' ' || screen_name)
            like lower('%$term%')) or ( screen_name is null and lower(email || ' ' || first_names || ' '||last_name )
            like lower('%$term%'))
      </querytext>
   </fullquery>
</queryset>

