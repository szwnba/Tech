<%@ Page Language="C#" %>


<script runat="server">
    protected void Page_Load(object sender, EventArgs e)
    {

    }
</script>

<!DOCTYPE html>


<html>
<head runat="server">
    <title></title>
 <%--   <script>
        var clearFields = function () {
            Ext.Msg.notify("Info.", "I'm here...");
        }
    </script>--%>
        <link rel="stylesheet" href="~/resources/css/clearad.css" />

    <script>
        //var ADDD = (function () {
        //    var el = Ext.DomHelper.append(document.body, {
        //        id: "unlicensed2"
        //    }, true);

            //var el = Ext.DomHelper.append(document.body, {
            //    id: "unlicensed"
            //}, false);
            //$('#unlicensed').remove();
            //Ext.select('unlicensed').remove();
        //});
 </script>
   <%-- <script>
        $(document).ready(function () {
            $('#unlicensed').remove();
        });
    </script>--%>

<%--    <script>
        Ext.onReady(function () {
            var el = Ext.DomHelper.append(document.body, {
                id: "unlicensed"
            }, true);
        });
 </script>--%>

   

    <link rel="stylesheet" href="<%= "../resources/css/main.css?" + Corp.Tool.Web.ExtNetVersion.Full %>" />

    <script>
        Ext.onReady(function () {
            if (top !== self) {
                Ext.select("a", true).on("click", function (e, el) {
                    if (!Ext.fly(el).hasCls("exclude")) {
                        parent.location = el.href;
                    }
                }, null, { preventDefault: true });
            }
        });
    </script>

</head>
<body class="welcome">
    <ext:ResourceManager runat="server" Theme="Triton" />

    <ext:Container runat="server">
        <Content>
            <div class="container">
                <div class="extnet-notification">
                    <div class="notification-container">
                        <div class="notification-img">
                            <img src="../resources/images/banner.png">
                        </div>
                        <div class="notification-text" id="TestCL">
                            <strong>Test Tool Online</strong>是一个在线测试工具系统，集合了一些常用的测试工具.
                       
                        </div>
                    </div>
                </div>

                <br />
                <h3>其它常用网站连接</h3>
                <ul class="popular-links">
                    <li><a href="http://xxx.com/apitroubleshootingsys/">一站式测试系统</a></li>
                    <li><a href="http://xxx/test-tool/">SOA服务测试工具</a></li>
                    <li><a href="http://xxx.com/SOA.TESTTOOL/default.aspx">WebService Test Tool</a></li>
                </ul>

            </div>
        </Content>
    </ext:Container>

</body>
</html>
