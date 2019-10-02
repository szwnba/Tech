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
            //加载QMQ分类
            qmqList = SnippetDBHelper.GetAllList("Python").DistinctBy(x => x.CataType).ToList();
            object[] SnippetData2 = new object[qmqList.Count];
            for (int i = 0; i < qmqList.Count; i++)
            {
                object[] obj = new object[] { qmqList[i].CataType, qmqList[i].CataType };
                SnippetData2[i] = obj;

            }
            SnippetData1 = SnippetData2;
        }
    }


    protected void TestCaseRefresh(object sender, StoreReadDataEventArgs e)
    {
        try
        {
            txtLogs.Text = "";
            List<SnippetEntity> selectCaseList = SnippetDBHelper.GetAllList("Python").Where(x => x.CataType == this.cmbSnippet.SelectedItem.Text).ToList(); ;
            this.storeTestCase.DataSource = selectCaseList;
            this.storeTestCase.DataBind();
            this.cmbTestCase.SelectedItem.Text = selectCaseList[0].Casename;
            this.txtLogs.Text = HighLighterUtils.CSharpToHtml(selectCaseList[0].Remark);


        }
        catch (Exception ex)
        {
            txtLogs.Text = ex.Message.ToString();
        }
    }

    protected void LoadRequest(object sender, DirectEventArgs e)
    {
        try
        {
            //Load Request
            string request = this.cmbTestCase.SelectedItem.Value;
            List<SnippetEntity> selectCaseList = SnippetDBHelper.GetAllList("Python").Where(x => x.CataType == this.cmbSnippet.SelectedItem.Text
                && x.Casename == this.cmbTestCase.SelectedItem.Text).ToList();
            if (selectCaseList != null && selectCaseList.Count > 0)
            {
                this.txtLogs.Text = HighLighterUtils.CSharpToHtml(selectCaseList[0].Remark);
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

    protected void btnAddSnippet_DirectClick(object sender, DirectEventArgs e)
    {
        txtAddCataType.Text = "";
        txtAddCasename.Text = "";
        txtAddRequest.Text = "";
        this.addWin.Show();
    }

    protected void btnEditSnippet_DirectClick(object sender, DirectEventArgs e)
    {
        this.editWin.Show();
        SnippetEntity SnippetEntity = SnippetDBHelper.GetSnippetByID("Python", this.cmbSnippet.SelectedItem.Text, this.cmbTestCase.SelectedItem.Text);
        if (SnippetEntity != null)
        {
            this.txtEditID.Text = SnippetEntity.Id.ToString();
            this.txtEditCataType.Text = SnippetEntity.CataType;
            this.txtEditCasename.Text = SnippetEntity.Casename;
            this.txtEditRequest.Text = SnippetEntity.Remark;
        }
        else
        {
            X.Msg.Alert("Message", "DB没有找到对应数据").Show();
        }
    }

    //add new pineline 
    protected void btnSaveAddWin_DirectClick(object sender, EventArgs e)
    {
        try
        {
            //Add
            SnippetEntity SnippetEntity = new SnippetEntity();
            SnippetEntity.Language = "Python";
            SnippetEntity.CataType = txtAddCataType.Text;
            SnippetEntity.Casename = txtAddCasename.Text;
            SnippetEntity.Remark = txtAddRequest.Text;
            int result = SnippetDBHelper.AddSnippet(SnippetEntity);
            X.Msg.Alert("Message", "保存成功").Show();
            addWin.Hide();
            //if (result == 1) Refresh();

        }
        catch (Exception ex)
        {
            X.Msg.Alert("Message", ex.Message.ToString()).Show();
        }
    }

    //add new pineline 
    protected void btnSaveEditWin_DirectClick(object sender, EventArgs e)
    {
        try
        {
            SnippetEntity SnippetEntity = new SnippetEntity();
            SnippetEntity.Id = Convert.ToInt32(txtEditID.Text);
            SnippetEntity.Language = "Python";
            SnippetEntity.CataType = txtEditCataType.Text;
            SnippetEntity.Casename = txtEditCasename.Text;
            SnippetEntity.Remark = txtEditRequest.Text;
            SnippetDBHelper.UpdateSnippet(SnippetEntity);
            X.Msg.Alert("Message", "保存成功").Show();
            editWin.Hide();
            //if (result == 1) Refresh();
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
    <title>Snippet Push</title>
    <link href="/resources/css/examples.css" rel="stylesheet" />
    <link rel="stylesheet" href="~/resources/css/clearad2.css" />
</head>
<body>
    <form runat="server">
        <ext:ResourceManager runat="server" />
        <ext:Panel runat="server" Title="Snippet" Layout="HBoxLayout">
            <Items>
                <ext:Panel
                    runat="server"
                    Border="false"
                    Height="750"
                    Width="1200"
                    BodyPadding="5"
                    ButtonAlign="Right">
                    <Items>
                        <ext:FieldSet
                            ID="FieldBooking"
                            runat="server"
                            ColumnWidth="1"
                            Title="Snippet"
                            MarginSpec="0 0 0 10"
                            ButtonAlign="Right">
                            <Defaults>
                                <ext:Parameter Name="LabelWidth" Value="40" />
                            </Defaults>
                            <Items>
                                <ext:ComboBox
                                    ID="cmbSnippet"
                                    runat="server"
                                    FieldLabel="分类"
                                    DisplayField="keytypename"
                                    ValueField="keytypenum"
                                    Width="200"
                                    QueryMode="Local"
                                    TypeAhead="true"
                                    EmptyText="请选择一个分类">
                                    <Listeners>
                                        <Select Handler="#{cmbTestCase}.clearValue(); #{storeTestCase}.reload();" />
                                    </Listeners>
                                    <Store>
                                        <ext:Store ID="storeName" runat="server" Data="<%# SnippetData1 %>" AutoDataBind="true">
                                            <Model>
                                                <ext:Model runat="server">
                                                    <Fields>
                                                        <ext:ModelField Name="keytypename" />
                                                        <ext:ModelField Name="keytypenum" />
                                                    </Fields>
                                                </ext:Model>
                                            </Model>
                                            <Reader>
                                                <ext:ArrayReader />
                                            </Reader>
                                        </ext:Store>
                                    </Store>
                                    <%--   <SelectedItems>
                                        <ext:ListItem Index="0" />
                                    </SelectedItems>--%>
                                </ext:ComboBox>

                                <ext:ComboBox
                                    ID="cmbTestCase"
                                    runat="server"
                                    FieldLabel="场景"
                                    DisplayField="casename"
                                    ValueField="Casename1"
                                    ForceSelection="true"
                                    TriggerAction="All"
                                    Width="200"
                                    QueryMode="Local"
                                    TypeAhead="true"
                                    EmptyText="请选择一个场景">
                                    <DirectEvents>
                                        <Select OnEvent="LoadRequest"></Select>
                                    </DirectEvents>
                                    <Store>
                                        <ext:Store ID="storeTestCase" runat="server" OnReadData="TestCaseRefresh" AutoLoad="false">
                                            <Model>
                                                <ext:Model runat="server">
                                                    <Fields>
                                                        <ext:ModelField Name="casename" Type="String" ServerMapping="Casename" />
                                                        <ext:ModelField Name="Casename1" Type="String" ServerMapping="Casename" />
                                                    </Fields>
                                                </ext:Model>
                                            </Model>
                                            <Listeners>
                                                <Load Handler="#{cmbTestCase}.setValue(#{cmbTestCase}.store.getAt(0));" />
                                            </Listeners>
                                        </ext:Store>
                                    </Store>

                                </ext:ComboBox>
                                <ext:HtmlEditor
                                    ID="txtLogs"
                                    runat="server"
                                    Height="540"
                                    EnableAlignments="false" EnableFontSize="False" EnableFont="False" EnableFormat="False" EnableLinks="False" EnableLists="False" EnableSourceEdit="False" EscapeValue="False" EnableColors="False">
                                </ext:HtmlEditor>
                            </Items>
                        </ext:FieldSet>

                    </Items>

                    <Buttons>
                        <ext:Button ID="btnAddSnippet" runat="server" Text="Add Snippet">
                            <DirectEvents>
                                <Click OnEvent="btnAddSnippet_DirectClick">
                                    <EventMask ShowMask="true" Msg="正在处理..."></EventMask>
                                </Click>
                            </DirectEvents>
                        </ext:Button>
                        <ext:Button ID="btnEditSnippet" runat="server" Text="Edit Snippet">
                            <DirectEvents>
                                <Click OnEvent="btnEditSnippet_DirectClick">
                                    <EventMask ShowMask="true" Msg="正在处理..."></EventMask>
                                </Click>
                            </DirectEvents>
                        </ext:Button>

                        <ext:Button ID="btnReload" runat="server" Text="Refresh">
                            <DirectEvents>
                                <Click OnEvent="btnReload_DirectClick">
                                    <EventMask ShowMask="true" Msg="正在处理..."></EventMask>
                                </Click>
                            </DirectEvents>
                        </ext:Button>
                    </Buttons>
                </ext:Panel>



            </Items>

        </ext:Panel>

        <ext:Window ID="addWin" runat="server" Title="Add Snippet Push" Icon="Application" Height="700" Width="600" Hidden="true" Modal="true">
            <Items>
                <ext:FieldSet
                    runat="server"
                    Title="Add Snippet ">
                    <Defaults>
                        <ext:Parameter Name="LabelWidth" Value="80" />
                    </Defaults>
                    <Items>
                        <ext:TextField ID="txtAddCataType" runat="server" FieldLabel="分类" Width="500" />
                        <ext:TextField ID="txtAddCasename" runat="server" FieldLabel="场景名称" Width="500" />
                        <ext:TextArea ID="txtAddRequest" runat="server" FieldLabel="代码" Width="540" Height="400" />
                    </Items>
                </ext:FieldSet>
            </Items>
            <Buttons>
                <ext:Button ID="btnAddSave" runat="server" Text="Save">
                    <DirectEvents>
                        <Click OnEvent="btnSaveAddWin_DirectClick">
                            <EventMask ShowMask="true" Msg="正在处理..."></EventMask>
                        </Click>
                    </DirectEvents>
                </ext:Button>
            </Buttons>
        </ext:Window>


        <ext:Window ID="editWin" runat="server" Title="Edit Pineline" Icon="Application" Height="700" Width="600" Hidden="true" Modal="true">
            <Items>
                <ext:FieldSet
                    runat="server"
                    Title="Edit">
                    <Defaults>
                        <ext:Parameter Name="LabelWidth" Value="80" />
                    </Defaults>
                    <Items>
                        <ext:TextField ID="txtEditID" runat="server" Disabled="true" FieldLabel="ID" Width="500" />
                        <ext:TextField ID="txtEditCataType" runat="server" FieldLabel="分类" Width="500" />
                        <ext:TextField ID="txtEditCasename" runat="server" FieldLabel="场景名称" Width="500" />
                        <ext:TextArea ID="txtEditRequest" runat="server" FieldLabel="代码" Width="540" Height="400" />
                    </Items>
                </ext:FieldSet>
            </Items>
            <Buttons>
                <ext:Button ID="btnEditSave" runat="server" Text="Save">
                    <DirectEvents>
                        <Click OnEvent="btnSaveEditWin_DirectClick">
                            <EventMask ShowMask="true" Msg="正在处理..."></EventMask>
                        </Click>
                    </DirectEvents>
                </ext:Button>
            </Buttons>
        </ext:Window>

    </form>
</body>
</html>
