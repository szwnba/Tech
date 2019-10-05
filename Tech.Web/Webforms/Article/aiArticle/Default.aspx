<%@ Page Language="C#" Async="true" ValidateRequest="false" %>

<%@ Import Namespace="System.Xml" %>
<%@ Import Namespace="System.Collections.Generic" %>
<%@ Import Namespace="Tech.Web" %>
<%@ Import Namespace="Tech.Web.Common" %>
<%@ Import Namespace="Tech.Web.Util" %>
<%@ Import Namespace="Tech.Entity.SOAEntity" %>
<%@ Import Namespace="Tech.Web.DB" %>
<%@ Import Namespace="Tech.Framework.Utility" %>

<script runat="server">

    public static string innerText = "";
    public List<SOAEntity> qmqList = new List<SOAEntity>();
    public object SOAData1;

    protected void Page_Load(object sender, EventArgs e)
    {

    }

    protected void btnSearch_DirectClick(object sender, DirectEventArgs e)
    {
        try
        {
            string url = "http://47.98.172.161:83/aiarticle";
            string requset = ("{\"inputtext\": \"{0}\"}");
            requset = requset.Replace("{0}", this.txtRequest.Text);
            txtLogs.Text = SendRequest(url, requset);
        }
        catch (Exception ex)
        {
            txtLogs.Text = ex.Message.ToString();
        }
    }

    private string SendRequest(string url, string request)
    {
        string response = "";
        if (request.StartsWith("{"))  //判断是否是JSON请求
        {
            response = SOAHelper.SendJsonRequest(url, request);
            response = JsonUtility.FormatJsonString(response);
        }
        else
        {
            response = SOAHelper.SendRequest(url, request);
            response = XmlHelper.FormatXml(response);
        }

        return response;
    }


</script>

<!DOCTYPE html>

<html>
<head runat="server">
    <title>智能写作</title>
    <link href="/resources/css/examples.css" rel="stylesheet" />
    <link rel="stylesheet" href="~/resources/css/clearad2.css" />
</head>
<body>
    <form runat="server">
        <ext:ResourceManager runat="server" />
        <ext:Panel runat="server" Layout="HBoxLayout">
            <Items>
                <ext:Panel
                    runat="server"
                    Border="false"
                    Height="640"
                    Width="600"
                    BodyPadding="5"
                    ButtonAlign="Right">
                    <Items>
                        <ext:FieldSet
                            ID="FieldBooking"
                            runat="server"
                            ColumnWidth="1"
                            Title="近义词转换"
                            MarginSpec="0 0 0 10"
                            ButtonAlign="Right">
                            <Defaults>
                                <ext:Parameter Name="LabelWidth" Value="40" />
                            </Defaults>
                            <Items>
                                <ext:TextArea ID="txtRequest" runat="server" Width="540" Height="350" />
                            </Items>
                        </ext:FieldSet>

                        <ext:Button ID="btnSearch" runat="server" Text="执行" Margin="10" PageX="500" Width="100">
                            <DirectEvents>
                                <Click OnEvent="btnSearch_DirectClick">
                                    <EventMask ShowMask="true" Msg="正在处理..."></EventMask>
                                </Click>
                            </DirectEvents>
                        </ext:Button>
                    </Items>
                </ext:Panel>

                <ext:Panel
                    runat="server"
                    Border="false"
                    Height="650"
                    Flex="1"
                    Layout="Fit"
                    BodyPadding="5">
                    <Items>
                        <ext:TextArea ID="txtLogs" runat="server" Width="540" Height="350" />
                    </Items>
                </ext:Panel>
            </Items>
        </ext:Panel>
    </form>
</body>
</html>
