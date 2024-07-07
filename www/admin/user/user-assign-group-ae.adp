<style>
    .form-widget .error {color:#c30000;}
    div.form-required-mark, strong.form-required-mark {font-size: 0;color:transparent;display:inline;}
    div.form-required-mark:after, strong.form-required-mark:after {color:red;content: "*";font-size:18px;font-weight:bold;}
</style>
<form id="group-user-info-form" class="margin-form">
    <div class="form-item-wrapper">
        <div class="form-label" style="font-weight:bold;">User Last Name:</div>
        <div class="form-widget" id="user_last_name"></div>
    </div>
    <div class="form-item-wrapper">
        <div class="form-label" style="font-weight:bold;">User First Name:</div>
        <div class="form-widget" id="user_first_names"></div>
    </div>
    <div class="form-item-wrapper">
        <div class="form-label" style="font-weight:bold;">Email:</div>
        <div class="form-widget" id="user_name"></div>
    </div>
    <div class="form-item-wrapper">
        <div class="form-label" style="font-weight:bold;">Screen Name:</div>
        <div class="form-widget" id="screen_name"></div>
    </div>
</form>
<formtemplate id="group_user_group_ae">
</formtemplate>

<script type="text/javascript" <if @::__csp_nonce@ not nil> nonce="@::__csp_nonce;literal@"</if>>
    $("#group_user_group_ae input[name=ok_btn]").addClass("btn btn-info");
    $("#group_user_group_ae .form-button").append("<button id='group-user-cancel-button' type='button' class='btn btn-default'>Cancel</button>");
    $("#group-user-cancel-button").click(function() {
        var url = "@return_url;literal@";
        location.href=url;
    });

    $(document).ready(function() {
        //$("label[for^='group_user_group_ae:elements:group_id_list:']").closest("div").find("span.form-label").wrap("<label></label>");
        //$("label[for^='group_user_group_ae:elements:group_id_list:']").css("font-weight", "normal");
        $("label[for^='group_user_group_ae:elements:mode:']").closest("div").find("span.form-label").wrap("<label></label>");
        $("label[for^='group_user_group_ae:elements:mode:']").css("font-weight", "normal");
        $("label[for^='group_user_group_ae:elements:mode:']").closest("span").find('br').remove();
        var mode_selected = $("#group_user_group_ae input[name=mode]:checked");
        if ( !mode_selected.val() ) {
             $("#group_user_group_ae input[name=mode][value=manual_membership_rel]").prop("checked", true);
        }        

        /*
        $('#user_group_ae').validate ({
            errorElement: "div",
            errorPlacement: function(error, element) {
                error.insertAfter( element );
            },
            rules: {
                "group_id_list":{"required":true}
            },
            messages: {
                "group_id_list": {"required":"Group Name Is Required."}
            }
        });
        */
    });
</script>    
