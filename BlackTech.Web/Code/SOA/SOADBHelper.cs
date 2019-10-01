using Ctrip.Automation.Framework.Lib;
using System;
using System.Collections.Generic;
using System.Data;
using MySql.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using MySql.Data.MySqlClient;
using BlackTech.API.Entity.SOAEntity;
using BlackTech.Framework.Utility;

namespace BlackTech.API.Framework.DB
{
    public class SOADBHelper 
    {
        public static string sConnection = "Server=47.98.172.161;Port=3306;Database=geekdb;UID=root;PWD=982128;";
        Database db = new Database(sConnection);

        public static List<SOAEntity> GetAllList(string type)
        {
            
            List<SOAEntity> list = new List<SOAEntity>();
            try
            {
                StringBuilder sqlCommand = new StringBuilder();
                sqlCommand.AppendFormat("select * from SOA where type = '{0}' ", type);
                DataTable dataTable = MySqlHelper.ExecuteDataset(sConnection, sqlCommand.ToString()).Tables[0];
                if (null != dataTable && dataTable.Rows.Count > 0)
                {
                    foreach (DataRow row in dataTable.Rows)
                    {
                        SOAEntity item = new SOAEntity();
                        item.Id = Convert.ToInt32(row["id"]);
                        item.Name = row["name"].ToString();
                        item.Url = row["url"].ToString();
                        item.Casename = row["casename"].ToString();
                        item.Requesttype = row["requesttype"].ToString();
                        item.Request = row["request"].ToString();
                        item.Datetime = row["datetime"].ToString();
                        list.Add(item);
                    }
                }
            }
            catch (Exception ex)
            {
                Log.Info("Catch exception when reading SOAEntity table. Exception=" + ex.Message);
                throw ex;
            }
            return list;
        }

        public static SOAEntity GetSOAByID(string name , string url , string casename)
        {
            //Database db = new Database(sConnection);
            SOAEntity item = null;
            try
            {
                string sqlCommand = String.Format("select * from SOA where name ='{0}' and url ='{1}' and casename ='{2}' ", name, url, casename);
                DataTable dataTable = MySqlHelper.ExecuteDataset(sConnection, sqlCommand).Tables[0];
                if (null != dataTable && dataTable.Rows.Count > 0)
                {
                    item = new SOAEntity();
                    foreach (DataRow row in dataTable.Rows)
                    {
                        item.Id = Convert.ToInt32(row["id"]);
                        item.Name = row["name"].ToString();
                        item.Url = row["url"].ToString();
                        item.Casename = row["casename"].ToString();
                        item.Requesttype = row["requesttype"].ToString();
                        item.Request = row["request"].ToString();
                        item.Datetime = row["datetime"].ToString();
                    }
                }
            }
            catch (Exception ex)
            {
                Log.Info("Catch exception when reading pinelineinfo table. Exception=" + ex.Message);
                throw ex;
            }
            return item;
        }


        public static int AddSOA(SOAEntity SOAEntity)
        {
            int result = 0;
            try
            {
                string sqlCommand = string.Format("insert into SOA (name,type, url,casename,requesttype,request,datetime) values ( '{0}','{1}','{2}','{3}','{4}','{5}','{6}')",
                    SOAEntity.Name, SOAEntity.Type,
                    SOAEntity.Url, SOAEntity.Casename, SOAEntity.Requesttype,SOAEntity.Request, DateTime.Now);
                result = MySqlHelper.ExecuteNonQuery(sConnection, sqlCommand);
            }
            catch (Exception ex)
            {
                Log.Info("Catch exception when adding SOAEntity table. Exception=" + ex.Message);
                throw ex;
            }
            return result;
        }

        public static int UpdateSOA(SOAEntity SOAEntity)
        {
            int result = 0;
            try
            {
                string sqlCommand = string.Format("update SOA set name='{0}',type='{1}',url='{2}',casename='{3}',requesttype='{4}',request='{5}',datetime='{6}'where id = {7}",
                    SOAEntity.Name, SOAEntity.Type,
                    SOAEntity.Url, SOAEntity.Casename, SOAEntity.Requesttype, SOAEntity.Request, DateTime.Now, SOAEntity.Id);
                result = MySqlHelper.ExecuteNonQuery(sConnection, sqlCommand);
            }
            catch (Exception ex)
            {
                Log.Info("Catch exception when update pinelineinfo table. Exception=" + ex.Message);
                throw ex;
            }
            return result;
        }

    }


}
