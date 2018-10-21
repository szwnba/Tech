<%@ Page Language="C#" Async="true" %>

<%@ Import Namespace="System.Xml" %>
<%@ Import Namespace="System.Collections.Generic" %>
<%@ Import Namespace="Corp.Tool.Web" %>
<%@ Import Namespace="System.IO" %>


<script runat="server">

    string appIDsPath = HttpContext.Current.Server.MapPath("~/Webforms/Media/Notepad/todo.txt");
    
    protected class IDInfo
    {
        public string AppID { get; set; }
        public string Name { get; set; }
    }
    
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        { 
            try
            {
                this.txtResult.Text = File.ReadAllText(appIDsPath);
            }
            catch (Exception ex)
            {
                X.Msg.Alert("Message", ex.Message.ToString()).Show();
            }
        }
    }


    protected void btnEdit_DirectClick(object sender, EventArgs e)
    {
         try
        {
            this.txtResult.Text = File.ReadAllText(appIDsPath);
        }
         catch (Exception ex)
         {
             X.Msg.Alert("Message", ex.Message.ToString()).Show();
         }
    }

    protected void btnSave_DirectClick(object sender, EventArgs e)
    {
         try
         {
             StreamWriter swOut = new StreamWriter(appIDsPath, false, Encoding.UTF8);
             swOut.WriteLine(this.txtResult.Text);
             swOut.Flush();
             swOut.Close();
         }
          catch (Exception ex)
          {
              X.Msg.Alert("Message", ex.Message.ToString()).Show();
          }
    }

</script>

<!DOCTYPE html>

<html>
<head runat="server">
    <title>记事本</title>
    <link href="/resources/css/examples.css" rel="stylesheet" />
    <link rel="stylesheet" href="~/resources/css/clearad.css" />
</head>
<body>

    <form runat="server">
        <ext:ResourceManager runat="server" />
        <ext:Panel runat="server"  Height="700" Layout="Fit"   Flex="1">
            <Items>
                  <ext:TextArea ID="txtResult" runat="server"  Height="600" >
                   </ext:TextArea>
             </Items>
                 <Buttons>
            <ext:Button ID="btnSave" runat="server" OnDirectClick="btnSave_DirectClick" Text="保存" >                
            </ext:Button>
             </Buttons>
        </ext:Panel>

    </form>
</body>
</html>
