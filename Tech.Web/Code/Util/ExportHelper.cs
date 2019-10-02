using Ext.Net;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using System.Web;
using System.Web.UI;
using System.Xml;
using System.Xml.Xsl;
using System.Data;

namespace Tech.Web.Util
{
    public class ExportHelper
    {
        public static void ToExcel(Page page, string json)
        {
            StoreSubmitDataEventArgs eSubmit = new StoreSubmitDataEventArgs(json, null);
            XmlNode xml = eSubmit.Xml;

            page.Response.ContentType = "application/vnd.ms-excel";
            page.Response.AddHeader("Content-Disposition", "attachment; filename=export.xls");
            XslCompiledTransform xtExcel = new XslCompiledTransform();
            xtExcel.Load(page.Server.MapPath("~/resources/excel/Excel.xsl"));
            xtExcel.Transform(xml, null, page.Response.OutputStream);
            page.Response.End();

        }

        public static void ToCsv( Page page ,string json)
        {
            StoreSubmitDataEventArgs eSubmit = new StoreSubmitDataEventArgs(json, null);
            XmlNode xml = eSubmit.Xml;

            page.Response.Clear();
            page.Response.ContentType = "application/octet-stream";
            page.Response.AddHeader("Content-Disposition", "attachment; filename=export.csv");

            XslCompiledTransform xtCsv = new XslCompiledTransform();

            xtCsv.Load(page.Server.MapPath("~/resources/excel/Csv.xsl"));
            xtCsv.Transform(xml, null, page.Response.OutputStream);
            page.Response.End();
        }

        public static string DataTableToJson(DataTable table)
        {
            var JsonString = new StringBuilder();
            if (table.Rows.Count > 0)
            {
                JsonString.Append("[");
                for (int i = 0; i < table.Rows.Count; i++)
                {
                    JsonString.Append("{");
                    for (int j = 0; j < table.Columns.Count; j++)
                    {
                        if (j < table.Columns.Count - 1)
                        {
                            JsonString.Append("\"" + table.Columns[j].ColumnName.ToString() + "\":" + "\"" + table.Rows[i][j].ToString() + "\",");
                        }
                        else if (j == table.Columns.Count - 1)
                        {
                            JsonString.Append("\"" + table.Columns[j].ColumnName.ToString() + "\":" + "\"" + table.Rows[i][j].ToString() + "\"");
                        }
                    }
                    if (i == table.Rows.Count - 1)
                    {
                        JsonString.Append("}");
                    }
                    else
                    {
                        JsonString.Append("},");
                    }
                }
                JsonString.Append("]");
            }
            return JsonString.ToString();
        }

    }
}