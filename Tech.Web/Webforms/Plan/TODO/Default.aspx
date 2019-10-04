<%@ Page Language="C#" Async="true" ValidateRequest="false" %>

<%@ Import Namespace="System.Xml" %>
<%@ Import Namespace="System.Collections.Generic" %>
<%@ Import Namespace="Tech.Web" %>
<%@ Import Namespace="Tech.Web.Common" %>
<%@ Import Namespace="Tech.Web.Util" %>
<%@ Import Namespace="Tech.Entity.SnippetEntity" %>
<%@ Import Namespace="Tech.Web.DB" %>
<%@ Import Namespace="Tech.Framework.Utility" %>

<script runat="server">

    public static string innerText = "";
    public List<SnippetEntity> qmqList = new List<SnippetEntity>();
    public object SnippetData1;

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!X.IsAjaxRequest)
        {
            LoadRequest();
        }
    }

    protected void LoadRequest()
    {
        try
        {
            //Load Request
            List<SnippetEntity> selectCaseList = SnippetDBHelper.GetAllList("Todo").Where(x => x.CataType == "Todo"
                            && x.Casename == "Todo").ToList(); ;
            if (selectCaseList != null && selectCaseList.Count > 0)
            {
                this.txtLogs.Text = selectCaseList[0].Remark;
            }
        }
        catch (Exception ex)
        {
            txtLogs.Text = ex.Message.ToString();
        }
    }

    protected void clean_Click(object sender, DirectEventArgs e)
    {
        this.txtLogs.Clear();
    }


    //add new pineline 
    protected void btnSaveEditWin_DirectClick(object sender, EventArgs e)
    {
        try
        {
            SnippetEntity SnippetEntity = new SnippetEntity();
            SnippetEntity.Id = 45;
            SnippetEntity.Language = "Todo";
            SnippetEntity.CataType = "Todo";
            SnippetEntity.Casename = "Todo";
            SnippetEntity.Remark = txtLogs.Text.Replace("\'", "\\'").Replace("\"", "\\\"");
            SnippetDBHelper.UpdateSnippet(SnippetEntity);
            X.Msg.Alert("Message", "保存成功").Show();
        }
        catch (Exception ex)
        {
            X.Msg.Alert("Message", ex.Message.ToString()).Show();
        }
    }

    //add new pineline 
    protected void btnReload_DirectClick(object sender, EventArgs e)
    {
        Page.Response.Redirect(Page.Request.Url.ToString(), true);
    }

</script>

<!DOCTYPE html>

<html>
<head runat="server">
    <title>TODO </title>
    <link href="/resources/css/examples.css" rel="stylesheet" />
</head>
<body>
    <form runat="server">
        <ext:ResourceManager runat="server" />
        <ext:Panel runat="server" Layout="HBoxLayout">
            <Items>
                <ext:Panel
                    runat="server"
                    Border="false"
                    Height="750"
                    Width="1200"
                    BodyPadding="5"
                    ButtonAlign="Right">
                    <Items>
                        <ext:TextArea ID="txtLogs" runat="server" Width="1200" Height="640" />
                    </Items>

                    <Buttons>
                        <ext:Button ID="btnEditSnippet" runat="server"  Text="Save">
                            <DirectEvents>
                                <Click OnEvent="btnSaveEditWin_DirectClick">
                                    <EventMask ShowMask="true" Msg="正在处理..."></EventMask>
                                </Click>
                            </DirectEvents>
                        </ext:Button>
                    </Buttons>
                </ext:Panel>
            </Items>
        </ext:Panel>
    </form>
</body>
</html>
