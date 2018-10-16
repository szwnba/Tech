<%@ Page Language="C#" Async="true"   %>

<%@ Import Namespace="System.Xml" %>
<%@ Import Namespace="System.Collections.Generic" %>


<script runat="server">

        
    protected void btnFocus_DirectClick(object sender, DirectEventArgs e)
    {
        try
        {
            //txtResult.
            //txtResult.Clear();
            //txtResult.Text = "teertettwte";
         }
        catch (Exception ex)
        {
            X.Msg.Alert("Message", ex.Message).Show();
        }
    }
    
</script>

<!DOCTYPE html>

<html>
<head runat="server">
    <title>ES 数据维护</title>
    <link href="/resources/css/examples.css" rel="stylesheet" />
    <link rel="stylesheet" href="~/resources/css/clearad.css" />
    <script>
        //光标移到text 中指定位置    
        function setCaret(control, pos) {
            var textbox = document.getElementById(control);
            //alert(132423);
            //textbox.selectionStart = 3;
            //alert(textbox.value);
            //textbox.setSelectionRange(textbox.selectionStart, textbox.selectionStart);
            //alert(textbox.selectionStart);
            textbox.focus();

            alert(textbox.scrollTop);
            textbox.scrollTop(100);

            //var r = textbox.createTextRange();
            //r.collapse(true);
            //r.moveStart('character', pos);
            //r.select();
            //textbox.focus();

        };

        /*
         * 设置输入域(input/textarea)光标的位置
         * @param {HTMLInputElement/HTMLTextAreaElement} elem
         * @param {Number} index
         */
        function setCursorPosition(control, index) {

            var elem = document.getElementById(control);
            var val = elem.value
            var len = val.length
            alert(len);
            elem.focus();
            // 超过文本长度直接返回
            //if (len < index) return
            //setTimeout(function () {
            //    elem.focus()

            //    if (elem.setSelectionRange) { // 标准浏览器              
            //        elem.setSelectionRange(index, index + 10);
            //        alert(index);
            //    } else { // IE9-
            //        var range = elem.createTextRange()
            //        range.moveStart("character", -len)
            //        range.moveEnd("character", -len)
            //        range.moveStart("character", index)
            //        range.moveEnd("character", 0)
            //        range.select()
            //    }
            //}, 20)
        };

        var insertAtCursor = function (myField, myValue) {
            myField1 = myField.el.dom;

            //myField.focus();
            alert(myField1.value);
            //if (document.selection) {
            //    myField.focus();
            //    sel = document.selection.createRange();
            //    sel.text = myValue;
            //} else if (myField.selectionStart || myField.selectionStart == '0') {
            //    var startPos = myField.selectionStart;
            //    var endPos = myField.selectionEnd;
            //    myField.value = myField.value.substring(0, startPos)
            //                  + myValue
            //                  + myField.value.substring(endPos, myField.value.length);

            //} else {
            //    myField.value += myValue;
            //}
        };
    </script>
</head>
<body>
    <form runat="server">
        <ext:ResourceManager runat="server" />
        <ext:Panel runat="server" Title="ES数据维护  -- 如需连接PROD环境请访问：http://172.18.68.113/" Layout="HBoxLayout">
            <Items>                

                <ext:Panel
                    runat="server"
                    Border="false"
                    Height="650"
                    Flex="1"
                    Layout="Fit"
                    BodyPadding="5">
                    <Items>
                      <%--  <ext:TextArea ID="txtResult" runat="server" Width="600" Height="600">
                        </ext:TextArea>--%>
                        <ext:HtmlEditor
                            ID="txtResult"
                            runat="server"
                            Height="600"
                           >
                        </ext:HtmlEditor>
                    </Items>
                </ext:Panel>


                <ext:Panel
                    ID="pnlConstruct"
                    runat="server"
                    Border="false"
                    Height="680"
                    BodyPadding="5">
                    <Items>
                        <ext:TreePanel
                            ID="TreePanel1"
                            runat="server"
                            Region="West"
                            Width="300"
                            Height="650"
                            Hidden="true">
                            <%--    <Listeners>
                            <ItemClick Handler="if (record.data.url) { loadPage(#{Pages}, record); return false;}" />
                        </Listeners>--%>
                        </ext:TreePanel>
                    </Items>
                </ext:Panel>
            </Items>
            <Buttons>

                <ext:Button runat="server" Text="FOCUS" ID="btnFocus" >
                      <Listeners>
                            <Click Handler= "setCaret('txtResult-inputCmp-textareaEl',2)" />
                        </Listeners>
                    </ext:Button>

            
            </Buttons>
        </ext:Panel>

    </form>
</body>
</html>
