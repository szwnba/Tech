<%@ Page Language="C#" %>

<script runat="server">
    protected void Page_Load(object sender, EventArgs e)
    {
      
    }
</script>

<!DOCTYPE html>

<html>
<head runat="server">
    <title>FormPanel - Ext.NET Examples</title>
    <link href="/resources/css/examples.css" rel="stylesheet" />

    <script>
        var template = '<span style="color:{0};">{1}</span>';

        var change = function (value) {
            return Ext.String.format(template, (value > 0) ? "green" : "red", value);
        };

        var pctChange = function (value) {
            return Ext.String.format(template, (value > 0) ? "green" : "red", value + "%");
        };
    </script>
</head>
<body>
    <form runat="server">
        <ext:ResourceManager runat="server" />

        <ext:FormPanel
            runat="server"
            Title="Company data"
            Width="1300"
            BodyPadding="5"
            Layout="ColumnLayout">

            <FieldDefaults LabelAlign="Left" MsgTarget="Side" />

            <Items>
               

                     <ext:FieldSet
                    runat="server"
                    ColumnWidth="0.5"
                    Title="Company details"
                    MarginSpec="0 0 0 10"
                    ButtonAlign="Right">
                    <Defaults>
                        <ext:Parameter Name="LabelWidth" Value="115" />
                    </Defaults>
                    <Items>
                        <ext:TextField Name="company" runat="server" FieldLabel="Name" />
                        <ext:TextField Name="price" runat="server" FieldLabel="Price" />
                        <ext:TextField Name="pctChange" runat="server" FieldLabel="Change (%)" />
                        <ext:DateField Name="lastChange" runat="server" FieldLabel="Last Updated" />
                        <ext:RadioGroup runat="server" FieldLabel="Rating (read-only)" ColumnsNumber="3" AutomaticGrouping="false">
                            <Items>
                                <ext:Radio runat="server" Name="rating" InputValue="0" BoxLabel="A" ReadOnly="true" />
                                <ext:Radio runat="server" Name="rating" InputValue="1" BoxLabel="B" ReadOnly="true" />
                                <ext:Radio runat="server" Name="rating" InputValue="2" BoxLabel="C" ReadOnly="true" />
                            </Items>
                        </ext:RadioGroup>
                    </Items>
                </ext:FieldSet>
           
              
             <ext:Toolbar runat="server" Layout="Container" Width="110" Flat="false">
                <Items>
                    <ext:Label runat="server"></ext:Label>

                    <ext:Button runat="server" Text="Test8 Fields" />
                    <ext:Label runat="server"></ext:Label>
                    <ext:Button runat="server" Text="Test9 Fields" />
                </Items>
            </ext:Toolbar>




                <ext:FieldSet
                    runat="server"
                    ColumnWidth="0.5"
                    Title="Company details"
                    MarginSpec="0 0 0 10"
                    ButtonAlign="Right">
                    <Defaults>
                        <ext:Parameter Name="LabelWidth" Value="115" />
                    </Defaults>
                    <Items>
                        <ext:TextField Name="company" runat="server" FieldLabel="Name" />
                        <ext:TextField Name="price" runat="server" FieldLabel="Price" />
                        <ext:TextField Name="pctChange" runat="server" FieldLabel="Change (%)" />
                        <ext:DateField Name="lastChange" runat="server" FieldLabel="Last Updated" />
                        <ext:RadioGroup runat="server" FieldLabel="Rating (read-only)" ColumnsNumber="3" AutomaticGrouping="false">
                            <Items>
                                <ext:Radio runat="server" Name="rating" InputValue="0" BoxLabel="A" ReadOnly="true" />
                                <ext:Radio runat="server" Name="rating" InputValue="1" BoxLabel="B" ReadOnly="true" />
                                <ext:Radio runat="server" Name="rating" InputValue="2" BoxLabel="C" ReadOnly="true" />
                            </Items>
                        </ext:RadioGroup>
                    </Items>
                </ext:FieldSet>
            </Items>
            
        </ext:FormPanel>
    </form>
</body>
</html>