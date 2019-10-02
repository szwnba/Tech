using Ext.Net;
using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using System.Web;
using System.Web.UI;
using System.Xml;

namespace Tech.Web.Util
{

    public class GridHelper
    {
        /// <summary>
        /// 生成字段和列，并绑定数据源
        /// </summary>
        /// <param name="_rptData"></param>
        /// <param name="_gp"></param>
        /// <param name="_store"></param>
        public static void BindData(Page page, DataTable table, GridPanel orderGrid)
        {
            Store store = new Store();
            store.Data = table;

            foreach (DataColumn _dataColumn in table.Columns)
            {
                //创建字段
                store.Fields.Add("_dataColumn.ColumnName");

                //创建列
                var _column = new Column
                {
                    Text = page.Server.HtmlEncode(_dataColumn.ColumnName),
                    DataIndex = _dataColumn.ColumnName,
                };
                orderGrid.ColumnModel.Columns.Add(_column);
            }
            orderGrid.Reconfigure(store, orderGrid.ColumnModel.Columns);
        }
    }
}