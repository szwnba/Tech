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
        <link rel="stylesheet" href="~/resources/css/clearad.css" />
        <link rel="stylesheet" href="<%= "../resources/css/main.css?" + Corp.Tool.Web.ExtNetVersion.Full %>" />

<%--    <script>
        Ext.onReady(function () {
            if (top !== self) {
                Ext.select("a", true).on("click", function (e, el) {
                    if (!Ext.fly(el).hasCls("exclude")) {
                        parent.location = el.href;
                    }
                }, null, { preventDefault: true });
            }
        });
    </script>--%>

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
                            <strong>BlackTech</strong>是一个在线辅助工具，集合一些日常的技术工具.
                       
                        </div>
                    </div>
                </div>

                <br />
                <h3>其它常用网站连接</h3>
                <ul class="popular-links">
                    <li><a href="https://studio.dev.tencent.com/ws/wdurlu">Cloud Studio</a></li>
                    <li><a href="https://uzer.me/">云端超级应用空间</a></li>
                </ul>

            </div>
        </Content>
    </ext:Container>

</body>
</html>
