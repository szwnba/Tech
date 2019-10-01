<%@ Page Language="C#" Async="true" validateRequest="false"%>

<%@ Import Namespace="System.Xml" %>
<%@ Import Namespace="System.Collections.Generic" %>
<%@ Import Namespace="Corp.Tool.Web" %>
<%@ Import Namespace="Corp.Tool.Web.Common" %>
<%@ Import Namespace="Corp.Tool.Web.Util" %>
<%@ Import Namespace="BlackTech.API.Entity.SOAEntity" %>
<%@ Import Namespace="BlackTech.API.Framework.DB" %>
<%@ Import Namespace="BlackTech.Framework.Utility" %>

<script runat="server">

    public static string innerText = "";
    public List<SOAEntity> qmqList = new List<SOAEntity>();
    public object SOAData1;

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!X.IsAjaxRequest)
        {
            //加载QMQ接口名称
            qmqList = SOADBHelper.GetAllList("SOA").DistinctBy(x => x.Name).ToList();
            object[] SOAData2 = new object[qmqList.Count];
            for (int i = 0; i < qmqList.Count; i++)
            {
                object[] obj = new object[] { qmqList[i].Name, qmqList[i].Url };
                SOAData2[i] = obj;

            }
            SOAData1 = SOAData2;
        }
    }

    private object RequestData
    {
        get
        {
            return new object[]
            {
                new object[] { "POST","POST"},
                new object[] { "GET","GET"}
          };
        }
    }

    protected void TestCaseRefresh(object sender, StoreReadDataEventArgs e)
    {
        try
        {
            txtLogs.Text = "";
            List<SOAEntity> selectCaseList = SOADBHelper.GetAllList("SOA").Where(x => x.Name == this.cmbSOA.SelectedItem.Text).ToList(); ;
            this.txtURL.Text = this.cmbSOA.SelectedItem.Value;
            this.storeTestCase.DataSource = selectCaseList;
            this.storeTestCase.DataBind();
            this.txtRequest.Text = selectCaseList[0].Request;
            if(selectCaseList[0].Requesttype!="")
                this.cmbRequestType.Value = selectCaseList[0].Requesttype;
            this.cmbTestCase.SelectedItem.Text = selectCaseList[0].Casename;
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
            List<SOAEntity> selectCaseList = SOADBHelper.GetAllList("SOA").Where(x => x.Name == this.cmbSOA.SelectedItem.Text
                && x.Casename == this.cmbTestCase.SelectedItem.Text).ToList();
            if (selectCaseList != null && selectCaseList.Count > 0)
            {
                this.txtURL.Text = selectCaseList[0].Url;
                this.txtRequest.Text = selectCaseList[0].Request;
                if(selectCaseList[0].Requesttype!="")
                    this.cmbRequestType.Value = selectCaseList[0].Requesttype;

            }

        }
        catch (Exception ex)
        {
            txtLogs.Text = ex.Message.ToString();
        }
    }

    protected void btnSearch_DirectClick(object sender, DirectEventArgs e)
    {
        try
        {
            string type = cmbRequestType.SelectedItem.Index >= 0 ? cmbRequestType.SelectedItem.Value : "POST";
            string response = SendRequest(txtURL.Text, type, txtRequest.Text);
            innerText = response;
            txtLogs.Text = HighLighterUtils.JsToHtml(response);
        }
        catch (Exception ex)
        {
            txtLogs.Text = ex.Message.ToString();
        }
    }

    private string SendRequest(string url, string requesttype ,string request)
    {
        string response = "";
        if (requesttype == "GET")
        {
            response = SOAHelper.SendGet(url);
            response = JsonUtility.FormatJsonString(response);
        }
        else if (request.StartsWith("{"))  //判断是否是JSON请求
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

    protected void clean_Click(object sender, DirectEventArgs e)
    {
        this.txtLogs.Clear();
    }

    protected void btnAddSOA_DirectClick(object sender, DirectEventArgs e)
    {
        txtAddName.Text = "";
        txtAddUrl.Text = "";
        txtAddCasename.Text = "";
        txtAddRequest.Text = "";
        this.addWin.Show();
    }

    protected void btnEditSOA_DirectClick(object sender, DirectEventArgs e)
    {
        this.editWin.Show();
        SOAEntity SOAEntity = SOADBHelper.GetSOAByID(this.cmbSOA.SelectedItem.Text, this.txtURL.Text, this.cmbTestCase.SelectedItem.Text);
        if (SOAEntity != null)
        {
            this.txtEditID.Text = SOAEntity.Id.ToString();
            this.txtEditName.Text = SOAEntity.Name;
            this.txtEditUrl.Text = SOAEntity.Url;
            if (SOAEntity.Requesttype !="")
                this.cmbEditRequestType.Value = SOAEntity.Requesttype;
            this.txtEditCasename.Text = SOAEntity.Casename;
            this.txtEditRequest.Text = SOAEntity.Request;
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
            SOAEntity SOAEntity = new SOAEntity();
            SOAEntity.Name = txtAddName.Text;
            SOAEntity.Type = "SOA";
            SOAEntity.Url = txtAddUrl.Text;
            SOAEntity.Casename = txtAddCasename.Text;
            if (cmbAddRequestType.SelectedItem.Index >= 0)
                SOAEntity.Requesttype = cmbAddRequestType.SelectedItem.Value;
            SOAEntity.Request = txtAddRequest.Text.Replace("\\\"", "\\\\\"");
            int result = SOADBHelper.AddSOA(SOAEntity);
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
            SOAEntity SOAEntity = new SOAEntity();
            SOAEntity.Id = Convert.ToInt32(txtEditID.Text);
            SOAEntity.Name = txtEditName.Text;
            SOAEntity.Type = "SOA";
            SOAEntity.Url = txtEditUrl.Text;
            SOAEntity.Casename = txtEditCasename.Text;
            if (cmbEditRequestType.SelectedItem.Index >= 0)
                SOAEntity.Requesttype = cmbEditRequestType.SelectedItem.Value;
            // 斜杠转义一下
            SOAEntity.Request = txtEditRequest.Text.Replace("\\\"", "\\\\\"");
            SOADBHelper.UpdateSOA(SOAEntity);
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
    <title>SOA Push 接口</title>
    <link href="/resources/css/examples.css" rel="stylesheet" />
    <link rel="stylesheet" href="~/resources/css/clearad2.css" />
</head>
<body>
    <form runat="server">
        <ext:ResourceManager runat="server" />
        <ext:Panel runat="server" Title="SOA Push 接口" Layout="HBoxLayout">
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
                            Title="SOA 接口"
                            MarginSpec="0 0 0 10"
                            ButtonAlign="Right">
                            <Defaults>
                                <ext:Parameter Name="LabelWidth" Value="40" />
                            </Defaults>
                            <Items>
                                <ext:ComboBox
                                    ID="cmbSOA"
                                    runat="server"
                                    FieldLabel="接口"
                                    DisplayField="keytypename"
                                    ValueField="keytypenum"
                                    Width="350"
                                    QueryMode="Local"
                                    TypeAhead="true"
                                    EmptyText="请选择一个接口">
                                    <Listeners>
                                        <Select Handler="#{cmbTestCase}.clearValue(); #{storeTestCase}.reload();" />
                                    </Listeners>
                                    <Store>
                                        <ext:Store ID="storeName" runat="server" Data="<%# SOAData1 %>" AutoDataBind="true">
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
                                <ext:TextField ID="txtURL" runat="server" FieldLabel="URL" Width="540" />

                                  <ext:ComboBox
                                    ID="cmbRequestType"
                                    runat="server"
                                    FieldLabel="类型"
                                    DisplayField="keytypename"
                                    ValueField="keytypenum"
                                    Width="350"
                                    QueryMode="Local"
                                    TypeAhead="true"
                                    EmptyText="请选择RequestType">
                                    <Listeners>
                                        <Select Handler="#{cmbTestCase}.clearValue(); #{storeTestCase}.reload();" />
                                    </Listeners>
                                    <Store>
                                        <ext:Store ID="store3" runat="server" Data="<%# RequestData %>" AutoDataBind="true">
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
                                    Width="500"
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
                        <ext:HtmlEditor
                            ID="txtLogs"
                            runat="server"
                            Height="600"
                            EnableAlignments="false" EnableFontSize="False" EnableFont="False" EnableFormat="False" EnableLinks="False" EnableLists="False" EnableSourceEdit="False" EscapeValue="False" EnableColors="False">
                        </ext:HtmlEditor>
                    </Items>
                </ext:Panel>
            </Items>
            <Buttons>

                <ext:Button ID="btnAddSOA" runat="server" Text="Add SOA">
                    <DirectEvents>
                        <Click OnEvent="btnAddSOA_DirectClick">
                            <EventMask ShowMask="true" Msg="正在处理..."></EventMask>
                        </Click>
                    </DirectEvents>
                </ext:Button>
                <ext:Button ID="btnEditSOA" runat="server" Text="Edit SOA">
                    <DirectEvents>
                        <Click OnEvent="btnEditSOA_DirectClick">
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

        <ext:Window ID="addWin" runat="server" Title="Add SOA Push" Icon="Application" Height="700" Width="600" Hidden="true" Modal="true">
            <Items>
                <ext:FieldSet
                    runat="server"
                    Title="Add New SOA Push">
                    <Defaults>
                        <ext:Parameter Name="LabelWidth" Value="80" />
                    </Defaults>
                    <Items>
                        <ext:TextField ID="txtAddName" runat="server" FieldLabel="接口名称" Width="500" />
                         <ext:ComboBox
                                    ID="cmbAddRequestType"
                                    runat="server"
                                    FieldLabel="类型"
                                    DisplayField="keytypename"
                                    ValueField="keytypenum"
                                    Width="350"
                                    QueryMode="Local"
                                    TypeAhead="true"
                                    EmptyText="请选择RequestType">
                                    <Listeners>
                                        <Select Handler="#{cmbTestCase}.clearValue(); #{storeTestCase}.reload();" />
                                    </Listeners>
                                    <Store>
                                        <ext:Store ID="store1" runat="server" Data="<%# RequestData %>" AutoDataBind="true">
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
                        <ext:TextField ID="txtAddUrl" runat="server" FieldLabel="Url" Width="500" />
                        <ext:TextField ID="txtAddCasename" runat="server" FieldLabel="场景名称" Width="500" />
                        <ext:TextArea ID="txtAddRequest" runat="server" FieldLabel="Request" Width="540" Height="400" />
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
                    Title="Edit Pineline">
                    <Defaults>
                        <ext:Parameter Name="LabelWidth" Value="80" />
                    </Defaults>
                    <Items>
                        <ext:TextField ID="txtEditID" runat="server" Disabled="true" FieldLabel="ID" Width="500" />
                        <ext:TextField ID="txtEditName" runat="server" FieldLabel="接口名称" Width="500" />
                          <ext:ComboBox
                                    ID="cmbEditRequestType"
                                    runat="server"
                                    FieldLabel="类型"
                                    DisplayField="keytypename"
                                    ValueField="keytypenum"
                                    Width="350"
                                    QueryMode="Local"
                                    TypeAhead="true"
                                    EmptyText="请选择RequestType">
                                    <Listeners>
                                        <Select Handler="#{cmbTestCase}.clearValue(); #{storeTestCase}.reload();" />
                                    </Listeners>
                                    <Store>
                                        <ext:Store ID="store2" runat="server" Data="<%# RequestData %>" AutoDataBind="true">
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
                        <ext:TextField ID="txtEditUrl" runat="server" FieldLabel="Url" Width="500" />
                        <ext:TextField ID="txtEditCasename" runat="server" FieldLabel="场景名称" Width="500" />
                        <ext:TextArea ID="txtEditRequest" runat="server" FieldLabel="Request" Width="540" Height="400" />
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
