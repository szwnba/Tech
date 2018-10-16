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
        <link rel="stylesheet" href="~/resources/css/clearad.css" />

    <script>

    </script>
</head>
<body >
    <form runat="server">
        <ext:ResourceManager runat="server" />

        <ext:FormPanel
            runat="server"
            Title="Redis值读取"
            Width="600"
            BodyPadding="5"
            Layout="ColumnLayout">

            <FieldDefaults LabelAlign="Left" MsgTarget="Side" />

            <Items>
        
                <ext:FieldSet
                    runat="server"
                    ColumnWidth="1"
                    Title=" "
                    MarginSpec="0 0 0 10"
                    ButtonAlign="Right">
                    <Defaults>
                        <ext:Parameter Name="LabelWidth" Value="115" />
                    </Defaults>
                    <Items>
                        <ext:ComboBox ID="cmbKeyType" runat="server" FieldLabel="KeyType" Width="350"></ext:ComboBox>
                        <ext:TextField Name="txtInput" runat="server" FieldLabel="Key" Width="350" />
                        <ext:TextArea ID="txtValue" runat="server" FieldLabel="Value" Width="520" Height="200">
                        </ext:TextArea>
                    </Items>
                </ext:FieldSet>
            </Items>
            <Buttons>

                <ext:Button runat="server" Text="读取">                
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