<%@ Page Language="C#" %>

<script runat="server">
    protected void Page_Load(object sender, EventArgs e)
    {
      
   
    }
</script>

<!DOCTYPE html>

<html>
<head runat="server">
    <title>Zeus</title>
    <link href="/resources/css/examples.css" rel="stylesheet" />

    <script>

    </script>
</head>
<body>
    <form runat="server">
        <ext:ResourceManager runat="server" />

        <ext:FormPanel
            runat="server"
            Title="神盾项目加密解密"
            Width="1000"
            BodyPadding="5"
            Layout="ColumnLayout">

            <FieldDefaults LabelAlign="Left" MsgTarget="Side" />

            <Items>
        
                <ext:FieldSet
                    runat="server"
                    ColumnWidth="0.4"
                    Title=" "
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
                        <ext:RadioGroup runat="server" FieldLabel="Rating" ColumnsNumber="3" AutomaticGrouping="false">
                            <Items>
                                <ext:Radio runat="server" Name="rating" InputValue="0" BoxLabel="A" />
                                <ext:Radio runat="server" Name="rating" InputValue="1" BoxLabel="B" />
                                <ext:Radio runat="server" Name="rating" InputValue="2" BoxLabel="C" />
                            </Items>
                        </ext:RadioGroup>
                    </Items>
                </ext:FieldSet>
            </Items>
            <Buttons>
                <ext:Button runat="server" Text="加密">                
                </ext:Button>
                <ext:Button runat="server" Text="解密">                
                </ext:Button>
                <ext:Button runat="server" Text="重置">
                    <Listeners>
                        <Click Handler="this.up('form').getForm().reset();" />
                    </Listeners>
                </ext:Button>
                
            </Buttons>
        </ext:FormPanel>
    </form>
</body>
</html>