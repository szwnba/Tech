using Ctrip.Automation.Framework.Lib;
using System;
using System.Collections.Generic;
using System.Data;
using MySql.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using MySql.Data.MySqlClient;
using Tech.Entity.SOAEntity;
using Tech.Framework.Utility;
using Tech.Entity.SnippetEntity;

namespace Tech.Web.DB
{
    public class SnippetDBHelper 
    {
        public static string sConnection = System.Web.Configuration.WebConfigurationManager.AppSettings["TechDB"];
        Database db = new Database(sConnection);

        public static List<SnippetEntity> GetAllList(string language)
        {
            List<SnippetEntity> list = new List<SnippetEntity>();
            try
            {
                StringBuilder sqlCommand = new StringBuilder();
                sqlCommand.AppendFormat("select * from Snippet where language = '{0}' ", language);
                DataTable dataTable = MySqlHelper.ExecuteDataset(sConnection, sqlCommand.ToString()).Tables[0];
                if (null != dataTable && dataTable.Rows.Count > 0)
                {
                    foreach (DataRow row in dataTable.Rows)
                    {
                        SnippetEntity item = new SnippetEntity();
                        item.Id = Convert.ToInt32(row["id"]);
                        item.Language = row["language"].ToString();
                        item.Casename = row["casename"].ToString();
                        item.CataType = row["catatype"].ToString();
                        item.Remark = row["remark"].ToString();
                        item.Datetime = row["datetime"].ToString();
                        list.Add(item);
                    }
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return list;
        }

        public static SnippetEntity GetSnippetByID(string language, string catatype, string casename)
        {
            //Database db = new Database(sConnection);
            SnippetEntity item = null;
            try
            {
                string sqlCommand = String.Format("select * from Snippet where language ='{0}' and catatype ='{1}' and casename ='{2}' ", language, catatype, casename);
                DataTable dataTable = MySqlHelper.ExecuteDataset(sConnection, sqlCommand).Tables[0];
                if (null != dataTable && dataTable.Rows.Count > 0)
                {
                    item = new SnippetEntity();
                    foreach (DataRow row in dataTable.Rows)
                    {
                        item.Id = Convert.ToInt32(row["id"]);
                        item.Language = row["language"].ToString();
                        item.Casename = row["casename"].ToString();
                        item.CataType = row["catatype"].ToString();
                        item.Remark = row["remark"].ToString();
                        item.Datetime = row["datetime"].ToString();
                    }
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return item;
        }


        public static int AddSnippet(SnippetEntity SnippetEntity)
        {
            int result = 0;
            try
            {
                string sqlCommand = string.Format("insert into Snippet (language,catatype, casename,remark,datetime) values ( '{0}','{1}','{2}','{3}','{4}')",
                    SnippetEntity.Language, SnippetEntity.CataType,
                    SnippetEntity.Casename, SnippetEntity.Remark, DateTime.Now);
                result = MySqlHelper.ExecuteNonQuery(sConnection, sqlCommand);
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return result;
        }

        public static int UpdateSnippet(SnippetEntity SnippetEntity)
        {
            int result = 0;
            try
            {
                string sqlCommand = string.Format("update Snippet set language='{0}',catatype='{1}',casename='{2}',remark='{3}',datetime='{4}'where id = {5}",
                    SnippetEntity.Language, SnippetEntity.CataType,
                   SnippetEntity.Casename, SnippetEntity.Remark,  DateTime.Now, SnippetEntity.Id);
                result = MySqlHelper.ExecuteNonQuery(sConnection, sqlCommand);
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return result;
        }

    }


}
