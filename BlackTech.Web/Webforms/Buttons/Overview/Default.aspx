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
            Width="1500"
            BodyPadding="5"
            Layout="ColumnLayout">

            <FieldDefaults LabelAlign="Left" MsgTarget="Side" />

            <Items>
               
                <ext:TextArea ID="TextArea1" runat="server" Width="600">
                </ext:TextArea>

             <ext:Toolbar runat="server" Layout="Container" Width="110" Flat="false">
                <Items>
                    <ext:Button runat="server" Text="Test8 Fields" />
                    <ext:Label runat="server"></ext:Label>
                    <ext:Button runat="server" Text="Test9 Fields" />
                </Items>
            </ext:Toolbar>

                    

                <ext:TextArea ID="TextArea2" runat="server" Width="600">
                </ext:TextArea>


                  



                
            </Items>
            <Buttons>
                <ext:Button runat="server" Text="Save To Grid">
                    <Listeners>
                        <Click Handler="var form = this.up('form'),
                                            r = form.getForm().getRecord();

                                        if (r) {
                                            form.getForm().updateRecord(form.down('grid').getSelectionModel().getLastSelected());
                                        }" />
                    </Listeners>
                </ext:Button>
                <ext:Button runat="server" Text="Reset Fields">
                    <Listeners>
                        <Click Handler="this.up('form').getForm().reset();" />
                    </Listeners>
                </ext:Button>
                <ext:Button runat="server" Text="Get Values...">
                    <Menu>
                        <ext:Menu runat="server">
                            <Items>
                                <ext:MenuItem runat="server" Text="Object">
                                    <Listeners>
                                        <Click Handler="alert(Ext.encode(this.up('form').getForm().getValues()));" />
                                    </Listeners>
                                </ext:MenuItem>
                                <ext:MenuItem runat="server" Text="String">
                                    <Listeners>
                                        <Click Handler="alert(this.up('form').getForm().getValues(true));" />
                                    </Listeners>
                                </ext:MenuItem>
                            </Items>
                        </ext:Menu>
                    </Menu>
                </ext:Button>
            </Buttons>
        </ext:FormPanel>
    </form>
</body>
</html>