<%@ Page Language="C#" %>

<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="Tech.Web.Common" %>


<script runat="server">
    public static string sConnection = System.Web.Configuration.WebConfigurationManager.AppSettings["TechDB"];
    public object DBObject1;
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!X.IsAjaxRequest)
        {
            //加载QMQ分类
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
            X.Msg.Alert("Status", ex.Message.ToString()).Show();

        }
    }

    protected void btnSearch_DirectClick(object sender, DirectEventArgs e)
    {
        try
        {
            DataTable table = null;
            string tablename = cmbMysqlTableList.SelectedItem.Value.ToString().Trim();
            table = MySqlDBHelper.GetTableDetail(sConnection, tablename);
            BindData(table, gpRPTData);
        }
        catch (Exception ex)
        {
            X.Msg.Alert("Status", ex.Message.ToString()).Show();

        }
    }
    protected void btnSqlSearch_DirectClick(object sender, DirectEventArgs e)
    {
        try
        {
            DataTable table = null;
            string tablename = cmbMysqlTableList.SelectedItem.Value.ToString().Trim();
            string sql = txtSQL.Text;
            table = MySqlDBHelper.GetTableDetailBySQL(sConnection, sql);
            BindData(table, gpRPTData);
        }
        catch (Exception ex)
        {
            X.Msg.Alert("Status", ex.Message.ToString()).Show();

        }
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
    <title>Search Order</title>
    <link href="/resources/css/examples.css" rel="stylesheet" />
    <script>
</script>
</head>
<body>
    <form runat="server">
        <ext:ResourceManager runat="server" />
        <ext:FormPanel
            runat="server"
            BodyPadding="2"
            Layout="ColumnLayout">
            <FieldDefaults LabelAlign="Left" MsgTarget="Side" />
            <Items>
                <ext:FieldSet
                    runat="server"
                    Title="查询数据库"
                    ColumnWidth="1"
                    ButtonAlign="Right">
                    <Defaults>
                        <ext:Parameter Name="LabelWidth" Value="40" />
                    </Defaults>
                    <Items>
                        <ext:ComboBox
                            ID="cmbMysqlDBList"
                            runat="server"
                            FieldLabel="DB"
                            DisplayField="keytypename"
                            ValueField="keytypenum"
                            Width="250"
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
                            FieldLabel="Table"
                            DisplayField="TABLE_NAME"
                            Width="250"
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
                        <ext:TextArea FieldLabel="SQL" runat="server" ID="txtSQL" Width="600"></ext:TextArea>

                        <ext:Button ID="btnSearch" runat="server" Text="表查询" Width="100" Margin="10">
                            <DirectEvents>
                                <Click OnEvent="btnSearch_DirectClick">
                                    <EventMask ShowMask="true" Msg="正在处理..."></EventMask>
                                </Click>
                            </DirectEvents>
                        </ext:Button>

                        <ext:Button ID="btnSQLSearch" runat="server" Text="SQL查询" Width="100" Margin="10">
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

        </ext:FormPanel>

    </form>
</body>
</html>
