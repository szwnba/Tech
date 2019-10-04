<%@ Page Language="C#" Async="true" ValidateRequest="false" %>

<%@ Import Namespace="System.Xml" %>
<%@ Import Namespace="System.Collections.Generic" %>
<%@ Import Namespace="Tech.Web" %>
<%@ Import Namespace="Tech.Web.Common" %>
<%@ Import Namespace="Tech.Web.Util" %>
<%@ Import Namespace="Tech.Entity.DBSQLGenEntity" %>
<%@ Import Namespace="Tech.Web.DB" %>
<%@ Import Namespace="Tech.Framework.Utility" %>
<%@ Import Namespace="System.Data" %>

<script runat="server">

    public static string innerText = "";
    public List<DBSQLGenEntity> nameList = new List<DBSQLGenEntity>();
    public object DBSQLGenData1;
    public static string sConnection = System.Web.Configuration.WebConfigurationManager.AppSettings["TechDB"];
    public object DBObject1;
    public static string dbname = "";
    public static string tablename = "";

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!X.IsAjaxRequest)
        {
            //加载QMQ分类
            nameList = DBSQLGenHelper.GetAllList().DistinctBy(x => x.Name).ToList();
            object[] DBSQLGenData2 = new object[nameList.Count];
            for (int i = 0; i < nameList.Count; i++)
            {
                object[] obj = new object[] { nameList[i].Name, nameList[i].Name };
                DBSQLGenData2[i] = obj;

            }
            DBSQLGenData1 = DBSQLGenData2;

            //加载DB
            List<string> dblist = MySqlDBHelper.ShowDBNames(sConnection);
            object[] DBObject2 = new object[dblist.Count];
            for (int i = 0; i < dblist.Count; i++)
            {
                object[] obj = new object[] { dblist[i], dblist[i] };
                DBObject2[i] = obj;

            }
            DBObject1 = DBObject2;
        }
    }

    protected void MysqlTableRefresh(object sender, StoreReadDataEventArgs e)
    {
        try
        {
            string dbname = cmbMysqlDBList.SelectedItem.Value;
            sConnection = string.Format("Server=47.98.172.161;Port=3306;Database={0};UID=root;PWD=982128", dbname);
            this.MysqlTableStore.Data = MySqlDBHelper.GetTableName(sConnection);
            this.MysqlTableStore.DataBind();
        }
        catch (Exception ex)
        {

        }
    }

    protected void TestCaseRefresh(object sender, StoreReadDataEventArgs e)
    {
        try
        {
            txtSQLText.Text = "";
            List<DBSQLGenEntity> selectCaseList = DBSQLGenHelper.GetAllList().Where(x => x.Name == this.cmbDBSQLGen.SelectedItem.Text).ToList(); ;
            this.storeTestCase.DataSource = selectCaseList;
            this.storeTestCase.DataBind();
            this.cmbTestCase.SelectedItem.Text = selectCaseList[0].SubName;
            dbname = selectCaseList[0].DBName;
            tablename = selectCaseList[0].TableName;
            this.txtSQLText.Text = selectCaseList[0].SQLText;

        }
        catch (Exception ex)
        {
            txtSQLText.Text = ex.Message.ToString();
        }
    }

    protected void LoadRequest(object sender, DirectEventArgs e)
    {
        try
        {
            //Load Request
            string request = this.cmbTestCase.SelectedItem.Value;
            List<DBSQLGenEntity> selectCaseList = DBSQLGenHelper.GetAllList().Where(x => x.Name == this.cmbDBSQLGen.SelectedItem.Text
                && x.SubName == this.cmbTestCase.SelectedItem.Text).ToList();
            if (selectCaseList != null && selectCaseList.Count > 0)
            {
                dbname = selectCaseList[0].DBName;
                tablename = selectCaseList[0].TableName;
                this.txtSQLText.Text = selectCaseList[0].SQLText;
            }

        }
        catch (Exception ex)
        {
            txtSQLText.Text = ex.Message.ToString();
        }
    }


    protected void clean_Click(object sender, DirectEventArgs e)
    {
        this.txtSQLText.Clear();
    }

    protected void btnAddDBSQLGen_DirectClick(object sender, DirectEventArgs e)
    {
        //txtAddCataType.Text = "";
        //txtAddCasename.Text = "";
        txtAddSQL.Text = "";
        this.addWin.Show();
    }

    protected void btnEditDBSQLGen_DirectClick(object sender, DirectEventArgs e)
    {
        this.editWin.Show();
        DBSQLGenEntity DBSQLGenEntity = DBSQLGenHelper.GetDBSQLByID(this.cmbDBSQLGen.SelectedItem.Text, this.cmbTestCase.SelectedItem.Text);
        if (DBSQLGenEntity != null)
        {
            this.txtEditID.Text = DBSQLGenEntity.Id.ToString();
            this.txtEditCataType.Text = DBSQLGenEntity.Name;
            this.txtEditCasename.Text = DBSQLGenEntity.SubName;
            this.txtEditDBName.Text = DBSQLGenEntity.DBName;
            this.txtEditTableName.Text = DBSQLGenEntity.TableName;
            this.txtEditSQL.Text = DBSQLGenEntity.SQLText;
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
            if (cmbMysqlDBList.SelectedItem.Index < 0 || cmbMysqlTableList.SelectedItem.Index < 0)
            {
                X.Msg.Alert("Message", "DB 或者 Table不能为空").Show();
                return;
            }
            //Add
            DBSQLGenEntity DBSQLGenEntity = new DBSQLGenEntity();
            DBSQLGenEntity.Name = txtAddCataType.Text;
            DBSQLGenEntity.SubName = txtAddCasename.Text;
            DBSQLGenEntity.DBName = cmbMysqlDBList.SelectedItem.Value;
            DBSQLGenEntity.TableName = cmbMysqlTableList.SelectedItem.Value;
            DBSQLGenEntity.SQLText = txtAddSQL.Text;//.Replace("\'", "\\'").Replace("\"", "\\\"");
            int result = DBSQLGenHelper.AddDBSQLGen(DBSQLGenEntity);
            X.Msg.Alert("Message", "保存成功").Show();
            addWin.Hide();
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
            DBSQLGenEntity DBSQLGenEntity = new DBSQLGenEntity();
            DBSQLGenEntity.Id = Convert.ToInt32(txtEditID.Text);
            DBSQLGenEntity.Name = txtEditCataType.Text;
            DBSQLGenEntity.SubName = txtEditCasename.Text;
            DBSQLGenEntity.DBName = txtEditDBName.Text;
            DBSQLGenEntity.TableName = txtEditTableName.Text;
            DBSQLGenEntity.SQLText = txtEditSQL.Text;//.Replace("\'", "\\'").Replace("\"", "\\\"");
            DBSQLGenHelper.UpdateDBSQLGen(DBSQLGenEntity);
            X.Msg.Alert("Message", "保存成功").Show();
            editWin.Hide();
        }
        catch (Exception ex)
        {
            X.Msg.Alert("Message", ex.Message.ToString()).Show();
        }
    }


    protected void btnSqlSearch_DirectClick(object sender, DirectEventArgs e)
    {
        try
        {
            DataTable table = null;
            sConnection = string.Format("Server=47.98.172.161;Port=3306;Database={0};UID=root;PWD=982128", dbname);
            string sql = txtSQLText.Text;
            table = MySqlDBHelper.GetTableDetailBySQL(sConnection, sql);
            BindData(table, gpRPTData);
        }
        catch (Exception ex)
        {
            X.Msg.Alert("Status", ex.Message.ToString()).Show();

        }
    }

    //add new pineline 
    protected void btnReload_DirectClick(object sender, EventArgs e)
    {
        Page.Response.Redirect(Page.Request.Url.ToString(), true);
    }


    /// <summary>
    /// 生成字段和列，并绑定数据源
    /// </summary>
    /// <param name="_rptData"></param>
    /// <param name="_gp"></param>
    /// <param name="_store"></param>
    private void BindData(DataTable table, GridPanel orderGrid)
    {
        Store store = new Store();
        store.Data = table;

        foreach (DataColumn _dataColumn in table.Columns)
        {
            //创建字段
            store.Fields.Add("_dataColumn.ColumnName");

            //创建列
            var _column = new Ext.Net.Column
            {
                Text = Server.HtmlEncode(_dataColumn.ColumnName),
                DataIndex = _dataColumn.ColumnName,
            };
            orderGrid.ColumnModel.Columns.Add(_column);
        }
        orderGrid.Reconfigure(store, orderGrid.ColumnModel.Columns);
    }
</script>

<!DOCTYPE html>

<html>
<head runat="server">
    <title>维度查询</title>
    <link href="/resources/css/examples.css" rel="stylesheet" />
    <link rel="stylesheet" href="~/resources/css/clearad2.css" />
</head>
<body>
    <form runat="server">
        <ext:ResourceManager runat="server" />
        <ext:Panel runat="server"  Layout="HBoxLayout">
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
                            Title="维度查询"
                            MarginSpec="0 0 0 10"
                            ButtonAlign="Right">
                            <Defaults>
                                <ext:Parameter Name="LabelWidth" Value="40" />
                            </Defaults>
                            <Items>
                                <ext:ComboBox
                                    ID="cmbDBSQLGen"
                                    runat="server"
                                    FieldLabel="分类"
                                    DisplayField="keytypename"
                                    ValueField="keytypenum"
                                    Width="250"
                                    QueryMode="Local"
                                    TypeAhead="true"
                                    EmptyText="请选择一个分类">
                                    <Listeners>
                                        <Select Handler="#{cmbTestCase}.clearValue(); #{storeTestCase}.reload();" />
                                    </Listeners>
                                    <Store>
                                        <ext:Store ID="storeName" runat="server" Data="<%# DBSQLGenData1 %>" AutoDataBind="true">
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
                                    Width="250"
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
                                                        <ext:ModelField Name="casename" Type="String" ServerMapping="SubName" />
                                                        <ext:ModelField Name="Casename1" Type="String" ServerMapping="SubName" />
                                                    </Fields>
                                                </ext:Model>
                                            </Model>
                                            <Listeners>
                                                <Load Handler="#{cmbTestCase}.setValue(#{cmbTestCase}.store.getAt(0));" />
                                            </Listeners>
                                        </ext:Store>
                                    </Store>
                                </ext:ComboBox>

                                <ext:TextArea FieldLabel="SQL"
                                    ID="txtSQLText"
                                    runat="server"
                                    Width="1000"
                                    Height="60">
                                </ext:TextArea>

                                <ext:Button ID="btnSQLSearch" runat="server" Text="查询" Width="100" Margin="10">
                                    <DirectEvents>
                                        <Click OnEvent="btnSqlSearch_DirectClick">
                                            <EventMask ShowMask="true" Msg="正在处理..."></EventMask>
                                        </Click>
                                    </DirectEvents>
                                </ext:Button>

                                <ext:GridPanel ID="gpRPTData" AutoScroll="true" Layout="Fit" TrackMouseOver="true" Selectable="true"
                                    runat="server" ColumnLines="true" StripeRows="true" Header="false" Title="查询" Height="400">
                                    <Store>
                                        <ext:Store ID="Store1" ShowWarningOnFailure="true" AutoLoad="true" runat="server" />
                                    </Store>
                                    <ColumnModel ID="ctl120" />
                                </ext:GridPanel>

                            </Items>
                        </ext:FieldSet>

                    </Items>

                    <Buttons>
                        <ext:Button ID="btnAddDBSQLGen" runat="server" Text="Add DBSQL">
                            <DirectEvents>
                                <Click OnEvent="btnAddDBSQLGen_DirectClick">
                                    <EventMask ShowMask="true" Msg="正在处理..."></EventMask>
                                </Click>
                            </DirectEvents>
                        </ext:Button>
                        <ext:Button ID="btnEditDBSQLGen" runat="server" Text="Edit DBSQL">
                            <DirectEvents>
                                <Click OnEvent="btnEditDBSQLGen_DirectClick">
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

        <ext:Window ID="addWin" runat="server" Title="Add DBSQL" Icon="Application" Height="700" Width="600" Hidden="true" Modal="true">
            <Items>
                <ext:FieldSet
                    runat="server"
                    Title="Add DBSQLGen ">
                    <Defaults>
                        <ext:Parameter Name="LabelWidth" Value="80" />
                    </Defaults>
                    <Items>
                        <ext:TextField ID="txtAddCataType" runat="server" FieldLabel="分类" Width="350" />
                        <ext:TextField ID="txtAddCasename" runat="server" FieldLabel="场景名称" Width="350" />
                        <ext:ComboBox
                            ID="cmbMysqlDBList"
                            runat="server"
                            FieldLabel="DB 列表"
                            DisplayField="keytypename"
                            ValueField="keytypenum"
                            Width="350"
                            QueryMode="Local"
                            EmptyText="Select a DB"
                            TypeAhead="true">
                            <Listeners>
                                <Select Handler="#{cmbMysqlTableList}.clearValue(); #{MysqlTableStore}.reload();" />
                            </Listeners>
                            <Store>
                                <ext:Store runat="server" Data="<%# DBObject1 %>" AutoDataBind="true">
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
                        </ext:ComboBox>

                        <ext:ComboBox
                            ID="cmbMysqlTableList"
                            runat="server"
                            FieldLabel="Table 列表"
                            DisplayField="TABLE_NAME"
                            Width="350"
                            QueryMode="Local"
                            TypeAhead="true"
                            ForceSelection="true"
                            TriggerAction="All"
                            EmptyText="Select a Table">
                            <Store>
                                <ext:Store ID="MysqlTableStore" runat="server" OnReadData="MysqlTableRefresh" AutoDataBind="false">
                                    <Model>
                                        <ext:Model runat="server">
                                            <Fields>
                                                <ext:ModelField Name="TABLE_NAME" Type="String" ServerMapping="TABLE_NAME" />
                                            </Fields>
                                        </ext:Model>
                                    </Model>
                                </ext:Store>
                            </Store>
                        </ext:ComboBox>

                        <ext:TextArea ID="txtAddSQL" runat="server" FieldLabel="SQL" Width="540" Height="400" />
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


        <ext:Window ID="editWin" runat="server" Title="Edit " Icon="Application" Height="700" Width="600" Hidden="true" Modal="true">
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
                        <ext:TextField ID="txtEditDBName" runat="server" FieldLabel="DB Name" Width="500" />
                        <ext:TextField ID="txtEditTableName" runat="server" FieldLabel="TableName" Width="500" />
                        <ext:TextArea ID="txtEditSQL" runat="server" FieldLabel="SQL" Width="540" Height="400" />
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
