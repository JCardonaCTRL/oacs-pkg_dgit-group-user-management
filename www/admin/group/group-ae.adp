<style>
    .name-textbox{width:320px;}
    input[type="checkbox"]{margin:5px;}
    div.form-required-mark, strong.form-required-mark {font-size: 0;color:transparent;display:inline;}
    div.form-required-mark:after, strong.form-required-mark:after {color:red;content: "*";font-size:18px;font-weight:bold;}
</style>

<formtemplate id="group_ae" class="margin-form"></formtemplate>

<script type="text/javascript"  <if @::__csp_nonce@ not nil> nonce="@::__csp_nonce;literal@"</if>>
    $('input[name=cancel_btn]').click(function() {
        var url = "@return_url;literal@";
        location.href=url;
    });
    $('input[name=ok_btn]').click(function() {
        var url = "@return_url;literal@";
        location.href=url;
    });
</script>
