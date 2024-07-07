<style>
    div.row {padding-top:2px !important; padding-bottom:10px !important;}
    .btn-default {color:#333333 !important;}
    #close-button {float: right;}
    #group-user-footer #close-button {display:none ;}
    #group-user-footer #close-button.vis {display:block ;}
   .help-text{font-size:12px;color:#666;}
</style>
<master>
<div class="container">
    <if @user_messages:rowcount@ gt 0>
      <div id="alert-message">
        <multiple name="user_messages">
        <div class="alert">
          <strong>@user_messages.message;noquote@</strong>
        </div>
        </multiple>
      </div>
    </if>

    <div class="row bg-warning">
        <h1>&nbsp;&nbsp;Group Name: @group_name;literal@</h1>
    </div>
    <br>
    <div class="row">
        <div class="col-sm-5">
            <button type="button" id="add-user-button" class="btn btn-success btn-sm" \
                data-title="Search User:" data-bs-toggle="modal" data-bs-target="#group-user-modal" data-toggle="modal" data-target="#group-user-modal" >
                Assign User To the Group</button>
            <a href="@back_url;literal@" class="btn btn-default btn-sm" title="Go Back">Go Back</a>
        </div>
        <div class="col-sm-7" align="right">
            <label>Mode Filter:</label>
            &nbsp;&nbsp;<input type="radio" name="mode" value="all">&nbsp;All
            &nbsp;&nbsp;<input type="radio" name="mode" value="manual_membership_rel">&nbsp;Manual
            &nbsp;&nbsp;<input type="radio" name="mode" value="auto_membership_rel">&nbsp;Automatical
            &nbsp;&nbsp;<input type="radio" name="mode" value="exclusion_membership_rel">&nbsp;Exclusion
        </div>
    </div>
    <br>
    <div class="table-responsive">
        <table cellpadding="0" cellspacing="0" border="0" class="table table-condensed table-striped" id="user_list" width="100%"> </table>
    </div>
</div>

<!-- include-user-modal -->
<div class="modal fade" id="include-user-modal" tabindex="-1" role="dialog" aria-labelledby="includeUserLabel">
   <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header resume-edit-model-header">
        <h4 class="modal-title resume_form_title" id="delete_header"></h4>
        <button type="button" class="btn-close" data-bs-dismiss="modal" data-dismiss="modal" id="aa_cancel_x" aria-label="Close"></button>
      </div>
      <div id="includeBox" class="modal-body">
            Are you sure you want to add the user into the group (@group_name;literal@)?
      </div>
      <div class="modal-footer">
        <button id="include-user" type="button" class="btn btn-info">Include User</button>
        <button type="button" class="btn btn-default" data-bs-dismiss="modal" data-dismiss="modal">Cancel</button>
      </div>
    </div>
   </div>
</div>

<!-- exclude-user-modal -->
<div class="modal fade" id="exclude-user-modal" tabindex="-1" role="dialog" aria-labelledby="excludeUserLabel">
   <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header resume-edit-model-header">
        <h4 class="modal-title resume_form_title" id="delete_header"></h4>
        <button type="button" class="btn-close" data-bs-dismiss="modal" data-dismiss="modal" id="aa_cancel_x" aria-label="Close"></button>
      </div>
      <div id="excludeBox" class="modal-body">
            Are you sure you want to exclude the user from the group (@group_name;literal@)?
      </div>
      <div class="modal-footer">
        <button id="exclude-user" type="button" class="btn btn-warning">Exclude User</button>
        <button type="button" class="btn btn-default" data-bs-dismiss="modal" data-dismiss="modal">Cancel</button>
      </div>
    </div>
   </div>
</div>

<!-- remove-user-modal -->
<div class="modal fade" id="remove-user-modal" tabindex="-1" role="dialog" aria-labelledby="removeUserLabel">
   <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header resume-edit-model-header">
        <h4 class="modal-title resume_form_title" id="delete_header"></h4>
        <button type="button" class="btn-close" data-bs-dismiss="modal" data-dismiss="modal" id="aa_cancel_x" aria-label="Close"></button>
      </div>
      <div id="removeBox" class="modal-body">
            Are you sure you want to remove the user from the group (@group_name;literal@)?
      </div>
      <div class="modal-footer">
        <button id="remove-user" type="button" class="btn btn-danger">Remove User</button>
        <button type="button" class="btn btn-default" data-bs-dismiss="modal" data-dismiss="modal">Cancel</button>
      </div>
    </div>
   </div>
</div>


<!-- group-user-modal -->
<div class="modal fade" id="group-user-modal" tabindex="-1" role="dialog" aria-labelledby="addProviderLabel">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header resume-edit-model-header">
                <h4 class="modal-title resume_form_title" id="user_header"></h4>
                <button type="button" class="btn-close" data-bs-dismiss="modal" data-dismiss="modal" id="aa_cancel_x" aria-label="Close"></button>
            </div>
            <div id="groupUserBox" class="modal-body">
                <div id="user_search_box">
                    <form class="form-horizontal">
                        <div class="form-group">
                            <label class="col-sm-12 control-label" for="group_user_info">Search for User:</label>
                            <div class="col-sm-12">
                                <input id="group_user_info" name="group_user_info" type="text" class="form-control autocomplete" autocomplete="off" placeholder="Enter here..."/>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-3 control-label" for="group_user_search_box2">&nbsp;</label>
                            <div class="col-sm-9" id="group_user_search_box2" class="hidden"></div>
                        </div>
                    </form>
                    <div class="help-text">
                        <span class="glyphicon glyphicon-info-sign"></span> Type in a name or email or screen name to search for a user in the system.
                    </div>
                </div>
            </div>
            <div class="modal-footer"></div>
        </div>
    </div>
</div>

<!-- group-user-edit-modal-->
<div class="modal fade" id="group-user-edit-modal" tabindex="-1" role="dialog" aria-labelledby="addProviderLabel">
    <div class="modal-dialog modal-lg" role="document">
        <div class="modal-content">
            <div class="modal-header resume-edit-model-header">
                <h4 class="modal-title resume_form_title" id="user_header"></h4>
                <button type="button" class="btn-close close-button" data-dismiss="modal" data-bs-dismiss="modal" id="aa_cancel_x" aria-label="Close"></button>
            </div>
            <div id="groupUserEditBox" class="modal-body">
                <include src="/packages/group-user-management/www/admin/user/user-assign-group-ae">
            </div>
            <div id="group-user-footer" class="modal-footer" align="right">
                <button id="close-button" type="button" class="btn btn-default close-button" href="@return_url;literal@">Close</button>
            </div>
        </div>
    </div>
</div>

<script type="text/javascript" <if @::__csp_nonce@ not nil> nonce="@::__csp_nonce;literal@"</if>>
    $('.close-button').click(function() {
        var url = $("#close-button").attr("href");
        location.href=url;
    });

    // set filter default value
    var mode_selected = $("[name=mode]:checked");
    if( !mode_selected.val() ) {
        $("[name=mode][value=@mode@]").prop("checked", true);
    }

    $("#group_user_info").keyup(function() {
        var userInfoValue = $("#group_user_info").val();
        if ( userInfoValue.length >= 2 ) {
            getGroupUserInfo(function(d) {
                $("#group_user_search_box2").empty();
                $.each(d, function(i, item) {
                    $("#group_user_search_box2").append("<p id='found_group_user_" + i + "'>" + item.label+"</p>");
                    $("#group_user_search_box2").removeClass("hidden");
                    $(".modal-body .error-message-1").remove();
                    $("#group_user_search_box2").show();

                    var selector = "#found_group_user_" + i;
                    $(selector).mouseout(function() {
                        $(this).css("background-color", "white");
                    }).mouseover(function() {
                        $(this).css("background-color", "lightgrey");
                    });

                    $(selector).click( function() {
                        $("#group-user-modal").modal('hide');
                        group_user_id = item.internalValue;
                        $("#group-user-edit-modal").modal('show');
                        $("input[type=hidden][name=user_id]").val(item.internalValue);
                        $("input[type=hidden][name=__new_p]").val(0);
                    });
                });
            });

            if ( userInfoValue.length > 3 && $("#group_user_search_box2").text() == "" ) {
                $(".modal-body .error-message-1").remove();
                var error_message = "<div class='error-message-1 alert alert-danger alert-dismissible' style='display:block'>";
                error_message += "<a class='close error-message-close' '>x</a>";
                error_message += "<strong>Error: There is not a user like " + userInfoValue + ".</strong></div>";
                $("#groupUserBox").append(error_message);
            }
        } else {
            $("#group_user_search_box2").text();
            $("#group_user_search_box2").addClass("hidden");
            $(".modal-body .error-message-1").remove();
        }
    });

    //*** group-user-modal
    $("#group-user-modal").on('show.bs.modal', function (event) {
        var button = $(event.relatedTarget); // Button that triggered the modal
        var title = button.data('title'); // Extract info from data-* attributes
        var modal = $(this);
        modal.find('.modal-title').text(title);
    });

    //*** group-user-edit-modal
    $("#group-user-edit-modal").on('show.bs.modal', function (event) {
        var button = $(event.relatedTarget); // Button that triggered the modal
        var title = button.data('title'); // Extract info from data-* attributes
        var modal = $(this);
        if( title !== undefined ) {
            modal.find('.modal-title').text(title);
        } else {
            modal.find('.modal-title').text("Assign the User To the Group:");
        }
        getSelectedGroupUserInfo(function(d) {
            $.each(d, function(i, item) {
                $("#group-user-info-form #user_last_name").text(item.user_last_name);
                $("#group-user-info-form #user_first_names").text(item.user_first_names);
                $("#group-user-info-form #user_name").text(item.user_name);
                $("#group-user-info-form #screen_name").text(item.screen_name);
                var mode = item.mode;
                if ( mode != "" ) {
                    $("#group_user_group_ae").remove();
                    $("#group-user-info-form").append("<br><p class=\"h5 text-danger\" " +
                        "style=\"font-weight:bold;\">" +
                        "Warning: The user had been assigned to the group with a mode \"" + mode +
                        "\".</p>");
                    $("#group-user-footer #close-button").addClass("vis");
                } else {
                    $("#group-user-footer #close-button").removeClass("vis");
                }
            });
        });
    });

    // include-user-modal
    $("#include-user-modal").on('show.bs.modal', function (event) {
        var button = $(event.relatedTarget); // Button that triggered the modal
        var group_id = button.data('group_id');
        var user_id = button.data('user_id');
        var title = button.data('title'); // Extract info from data-* attributes
        var destination = button.data('destination');
        var modal = $(this);

        modal.find('.modal-title').text(title);
        $("#include-user").click(function() {
            location.href = destination;
        });
    });

    // exclude-user-modal
    $("#exclude-user-modal").on('show.bs.modal', function (event) {
        var button = $(event.relatedTarget); // Button that triggered the modal
        var group_id = button.data('group_id');
        var user_id = button.data('user_id');
        var title = button.data('title'); // Extract info from data-* attributes
        var destination = button.data('destination');
        var modal = $(this);

        modal.find('.modal-title').text(title);
        $("#exclude-user").click(function() {
            location.href = destination;
        });
    });

    // remove-user-modal
    $("#remove-user-modal").on('show.bs.modal', function (event) {
        var button = $(event.relatedTarget); // Button that triggered the modal
        var group_id = button.data('group_id');
        var user_id = button.data('user_id');
        var title = button.data('title'); // Extract info from data-* attributes
        var destination = button.data('destination');
        var modal = $(this);

        modal.find('.modal-title').text(title);
        $("#remove-user").click(function() {
            location.href = destination;
        });
    });

    function getGroupUserInfo (callback) {
        var term = $("#group_user_info").val();
        $.ajax({
            url: '@user_ajax_query_url;literal@',
            data: {term:term},
            success: function(resp) {
                data = resp;
                callback(data);
            },
            error: function() {}
        });
    }

    function getSelectedGroupUserInfo (callback) {
        $.ajax({
            url: '@selected_group_user_ajax_query_url;literal@',
            data: {user_id:group_user_id, group_id:@group_id@},
            success: function(resp) {
                data = resp;
                callback(data);
            },
            error: function() {}
        });
    }

    $(document).ready(function() {
        $("#alert-message").fadeTo(2000, 500).slideUp(500, function() {
            $("#alert-message").slideUp(500);
        });
        var mode = $("input[name=mode]:checked").val();
        var groupDatatable = $('#user_list').DataTable ({
            "destroy":true,
            "columns": [
                {"data":"first_names", "title": "First Name", "orderable":true, "class":"left", "width":"120px"},
                {"data":"last_name", "title":"Last Name", "orderable":true, "class":"left"},
                {"data":"email", "title":"Email", "orderable":false, "class":"left"},
                {"data":"screen_name", "title":"Screen Name", "orderable":true, "class":"left"},
                {"data":"mode", "title":"Mode", "orderable":false, "class":"left"},
                {"data": "actions", "title": "Actions", "orderable": false, "class": "left", "visible": true}
            ],
           "processing": true,
           "serverSide": true,
           "searching":  true,
           "paging":     true,
           "pageLength": 25,
           "stateSave":  true,
           "bSort": true,
           "ajax": {
                "url":"@user_list_ajax_url;noquote@&mode=" + mode,
                "method": "get"
            },
            "order": [["0","asc"]]
        });

        $("input[type=radio][name=mode]").change(function() {
            var mode = $("input[name=mode]:checked").val();
            var task_status = $("input[name=task_status]:checked").val();
            var json_url = "@user_list_ajax_url;literal@";
            json_url += "&mode=" + mode ;
            groupDatatable.ajax.url(json_url).load();
        });

    });
</script>
