<master>
<style>
    div.row {padding-top:2px !important; padding-bottom:10px !important;}
   .dataTables_filter {text-align: right;}
   .panel.panel-default {position:absolute;right:4em;left:4em;}
   .table-responsive {overflow-x:inherit !important;}
   #close-button {float: right;}
   .btn-default {color:#333333 !important;}
   /*.user-search{width:75%;}*/
   .help-text{font-size:12px;color:#666;}
</style>
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
    <div class="row">
        <div class="col-sm-4">
            <h1>Group User Management</h1>
        </div>
        <div class="col-sm-8" style="padding-top:20px;">
            <button type="button" id="upload-button" class="btn btn-success btn-sm" \
                data-toggle="modal" data-target="#group-modal" data-bs-toggle="modal" data-bs-target="#group-modal" data-title="New Group:" >
                Add Group </button>
            <button type="button" id="add-user-button" class="btn btn-success btn-sm" \
                data-title="Search User:" data-bs-toggle="modal" data-bs-target="#user-modal" data-toggle="modal" data-target="#user-modal">
                Search User</button>
        </div>
    </div>
    <br>
    <div class="table-responsive">
        <table cellpadding="0" cellspacing="0" border="0" class="table table-condensed table-striped" id="group_list" width="100%"> </table>
    </div>
</div>

<!-- group-modal -->
<div class="modal fade" id="group-modal" tabindex="-1" role="dialog" aria-labelledby="addGroupLabel">
  <div class="modal-dialog modal-lg" role="document">
    <div class="modal-content">
      <div class="modal-header resume-edit-model-header">
        <h4 class="modal-title resume_form_title" id="group_header">Add Group</h4>
        <button type="button" class="btn-close"  data-bs-dismiss="modal" data-dismiss="modal" id="aa_cancel_x" aria-label="Close"></button>
      </div>
      <div id="groupBox" class="modal-body">
            <include src="/packages/group-user-management/www/admin/group/group-ae" >
      </div>
    </div>
  </div>
</div>

<!-- user-modal -->
<div class="modal fade" id="user-modal" tabindex="-1" role="dialog" aria-labelledby="addProviderLabel">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header resume-edit-model-header">
                <h4 class="modal-title resume_form_title" id="user_header"></h4>
                <button type="button" class="btn-close"  data-bs-dismiss="modal" data-dismiss="modal" id="aa_cancel_x" aria-label="Close"></button>
            </div>
            <div id="userBox" class="modal-body">
                <div id="user_search_box">
                    <form class="form-horizontal">
                        <div class="form-group">
                            <label class="col-sm-12 control-label" for="user_info">Search for User:</label>
                            <div class="col-sm-12">
                                <input id="user_info" name="user_info" type="text" class="user-search form-control autocomplete" autocomplete="off" placeholder="Enter here..."/>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-3 control-label" for="user_search_box2">&nbsp;</label>
                            <div class="col-sm-9" id="user_search_box2" class="hidden"></div>
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

<!-- user-edit-modal-->
<div class="modal fade" id="user-edit-modal" tabindex="-1" role="dialog" aria-labelledby="addProviderLabel">
    <div class="modal-dialog modal-lg" role="document">
        <div class="modal-content">
            <div class="modal-header resume-edit-model-header">
                <h4 class="modal-title resume_form_title" id="user_header"></h4>
                <button type="button" class="btn-close close-button"  data-bs-dismiss="modal" data-dismiss="modal" id="aa_cancel_x" aria-label="Close"></button>
            </div>
            <div id="userEditBox" class="modal-body">
                <include src="/packages/group-user-management/www/admin/user/user-group-ae">
            </div>
            <div class="modal-footer">
                <button id='close-button' type='button' class='btn btn-default close-button' href='@return_url;literal@'>Close</button>
            </div>
        </div>
    </div>
</div>

<!-- delete-group-modal -->
<div class="modal fade" id="delete-group-modal" tabindex="-1" role="dialog" aria-labelledby="removeGroupLabel">
   <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header resume-edit-model-header">
        <h4 class="modal-title resume_form_title" id="delete_header"></h4>
        <button type="button" class="btn-close"  data-bs-dismiss="modal" data-dismiss="modal" id="aa_cancel_x" aria-label="Close"></button>
      </div>
      <div id="removeBox" class="modal-body">
            Are you sure you want to delete the group?
      </div>
      <div class="modal-footer">
        <button id="delete-group" type="button" class="btn btn-danger">Delete Group</button>
        <button type="button" class="btn btn-default"  data-bs-dismiss="modal">Cancel</button>
      </div>
    </div>
   </div>
</div>

<script type="text/javascript" <if @::__csp_nonce@ not nil> nonce="@::__csp_nonce;literal@"</if>>
    $('.close-button').click(function() {
        var url = $("#close-button").attr("href");
        location.href=url;
    });

    $("#user_info").keyup(function() {
        var userInfoValue = $("#user_info").val();
        if ( userInfoValue.length >= 2 ) {
            getUserInfo(function(d) {
                $("#user_search_box2").empty();
                $.each(d, function(i, item) {
                    $("#user_search_box2").append("<p id='found_user_" + i + "'>" + item.label+"</p>");
                    $("#user_search_box2").removeClass("hidden");
                    $(".modal-body .error-message-1").remove();
                    $("#user_search_box2").show();

                    var selector = "#found_user_" + i;
                    $(selector).mouseout(function() {
                        $(this).css("background-color", "white");
                    }).mouseover(function() {
                        $(this).css("background-color", "lightgrey");
                    });

                    $(selector).click( function() {
                        user_id = item.internalValue;
                        $("#user-modal").modal('hide');
                        $("#user-edit-modal").modal('show');
                        $("input[type=hidden][name=user_id]").val(item.internalValue);
                        $("input[type=hidden][name=__new_p]").val(0);
                    });
                });
            });

            if ( userInfoValue.length > 3 && $("#user_search_box2").text() == "" ) {
                $(".modal-body .error-message-1").remove();
                var error_message = "<div class='error-message-1 alert alert-danger alert-dismissible' style='display:block'>";
                error_message += "<a class='close error-message-close' '>x</a>";
                error_message += "<strong>Error:</strong> The system could not find " + userInfoValue + ". Please try again.</div>";
                $("#userBox").append(error_message);
            }
        } else {
            $("#user_search_box2").text();
            $("#user_search_box2").addClass("hidden");
            $(".modal-body .error-message-1").remove();
        }
    });

    //*** user-modal
    $("#user-modal").on('show.bs.modal', function (event) {
        var button = $(event.relatedTarget); // Button that triggered the modal
        var title = button.data('title'); // Extract info from data-* attributes
        var modal = $(this);
        modal.find('.modal-title').text(title);
    });

    //*** user-edit-modal
    $("#user-edit-modal").on('show.bs.modal', function (event) {
        $("#userEditBox #group_num").remove();
        $("#userEditBox #group_list").remove();
        var button = $(event.relatedTarget); // Button that triggered the modal
        var title = button.data('title'); // Extract info from data-* attributes
        var modal = $(this);
        if( title !== undefined ) {
            modal.find('.modal-title').text(title);
        } else {
            modal.find('.modal-title').text("View Groups Assigned to the User:");
        }

        getSelectedUserInfo(function(d) {

            $.each(d, function(i, item) {
                $("#user_last_name").text(item.user_last_name);
                $("#user_first_names").text(item.user_first_names);
                $("#user_name").text(item.user_name);
                $("#screen_name").text(item.screen_name);
                var group_num = item.group_num;
                var group_num_content = "<div id=\"group_num\" class=\"form-item-wrapper\">" +
                        "<div class=\"form-label\" style=\"font-weight:bold;\">Number of Groups Assigned:" +
                        "</div>" +
                        "<div class=\"form-widget\" id=\"screen_name\">" + group_num.toString() +
                        "</div></div>";
                $("form[class=margin-form]").append(group_num_content);

                if ( group_num > 0 ) {
                    var html_content = "<div id=\"group_list\" class=\"form-item-wrapper\">" +
                        "<div class=\"form-label\" style=\"font-weight:bold;\">Group List: </div>" +
                        "<div class=\"form-widget\">" + item.group_rel_list + "</div></div>";
                    $("form[class=margin-form]").append(html_content);
                }
            });
        });
    });

    // delete-group-modal
    $("#delete-group-modal").on('show.bs.modal', function (event) {
        var button = $(event.relatedTarget); // Button that triggered the modal
        var group_id = button.data('group_id');
        var title = button.data('title'); // Extract info from data-* attributes
        var destination = button.data('destination');
        var modal = $(this);

        modal.find('.modal-title').text(title);
        $("#delete-group").click(function() {
            location.href = destination;
        });
    });

    $("#group-modal").on('show.bs.modal', function (event) {
        var button = $(event.relatedTarget); // Button that triggered the modal
        var title = button.data('title'); // Extract info from data-* attributes
        var group_id = button.data('group_id');
        var modal = $(this);
        modal.find('.modal-title').text(title);
	resetGroupForm();
        if ( group_id !== undefined ){
            $("input[type=hidden][name=group_id]").val(group_id);
	    $("input[type=hidden][name=__new_p]").val(0);
            $("input[type=submit][name=ok_btn]").val("Edit");
            getGroupInfo(function(d) {
                $("input[name=group_name]").val(d.groupName);
                $("input[name=group_code]").val(d.groupCode);
		for(var i=0; i<d.ouGroups.length; i++)
		{
                   $("input[value='"+d.ouGroups[i]+"']").prop("checked", true);
		}
            });
        }
    });

    function getGroupInfo(callback) {
        var group_id = $("input[name=group_id]").val();
        $.ajax({
            url: '@group_ajax_query_url;literal@',
            data: {group_id:group_id},
            success: function(resp) {
                data = resp;
                callback(data);
            },
            error: function() {}
        });
    }

    function resetGroupForm() {
	$("input[name=group_name]").val('');
	$("input[name=group_code]").val('');
	$("input[name=ous]").prop("checked", false);
	$("input[type=submit][name=ok_btn]").val("Add");
    }

    function getUserInfo (callback) {
        var term = $("#user_info").val();
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

    function getSelectedUserInfo (callback) {
        $.ajax({
            url: '@selected_user_ajax_query_url;literal@',
            data: {user_id:user_id},
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

        var groupDatatable = $('#group_list').DataTable ({
            "destroy":true,
            "columns": [
                {"data":"group_name", "title": "Name", "orderable":true, "class":"left", "width":"120px"},
                {"data":"num_of_users", "title":"No. of Users", "orderable":true, "class":"left"},
                {"data":"num_of_automatic", "title":"Automatically Added", "orderable":false, "class":"left"},
                {"data":"num_of_manual", "title":"Manually Added", "orderable":false, "class":"left"},
                {"data":"num_of_exclusion", "title":"Exclusion List", "orderable":false, "class":"left"},
              //  {"data":"ou_group_list", "title":"OU Groups", "orderable":true, "class":"left"},
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
                "url":"@group_list_ajax_url;noquote@",
                "method": "get"
            },
            "order": [["0","asc"]]
        });
    });
</script>
