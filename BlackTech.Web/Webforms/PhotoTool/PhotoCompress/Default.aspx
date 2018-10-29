<%@ Page Language="C#" %>

<script runat="server">
    protected void Page_Load(object sender, EventArgs e)
    {
        Ext.Net.Panel win = new Ext.Net.Panel()
          //Window win = new Window()
          {
              ID = "PhotoCompress",
              //Title = "Í¼Æ¬Ñ¹Ëõ",
              //Width = Unit.Pixel(1500),
              Height = Unit.Pixel(800),
              Layout = "Fit",
              Flex = 1,
              //Modal = true,
              AutoRender = false,
              Collapsible = false,
              //Maximizable = true,
              Hidden = true,
              Loader = new ComponentLoader
              {
                  Url = "https://tinypng.com",
                  Mode = LoadMode.Frame,
                  LoadMask =
                  {
                      ShowMask = true
                  }
              }
          };

        this.Form.Controls.Add(win);
        win.Show();
    }
</script>

<!DOCTYPE html>

<html>
<head runat="server">
    <title>Í¼Æ¬Ñ¹Ëõ</title>
    <link href="/resources/css/examples.css" rel="stylesheet" />
    <link rel="stylesheet" href="~/resources/css/clearad.css" />
</head>
<body>
    <form runat="server">
        <ext:ResourceManager runat="server" />
    
    </form>
</body>
</html>