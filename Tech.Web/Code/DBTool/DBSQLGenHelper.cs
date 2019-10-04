using Ctrip.Automation.Framework.Lib;
using System;
using System.Collections.Generic;
using System.Data;
using System.Text;
using MySql.Data.MySqlClient;
using Tech.Entity.DBSQLGenEntity;

namespace Tech.Web.DB
{
    public class DBSQLGenHelper
    {
        public static string sConnection = System.Web.Configuration.WebConfigurationManager.AppSettings["TechDB"];
        Database db = new Database(sConnection);

        public static List<DBSQLGenEntity> GetAllList()
        {
            List<DBSQLGenEntity> list = new List<DBSQLGenEntity>();
            try
            {
                StringBuilder sqlCommand = new StringBuilder();
                sqlCommand.Append("select * from dbsql ");
                DataTable dataTable = MySqlHelper.ExecuteDataset(sConnection, sqlCommand.ToString()).Tables[0];
                if (null != dataTable && dataTable.Rows.Count > 0)
                {
                    foreach (DataRow row in dataTable.Rows)
                    {
                        DBSQLGenEntity item = new DBSQLGenEntity();
                        item.Id = Convert.ToInt32(row["id"]);
                        item.Name = row["name"].ToString();
                        item.SubName = row["subName"].ToString();
                        item.DBName = row["dbname"].ToString();
                        item.TableName = row["tablename"].ToString();
                        item.SQLText = row["sqltext"].ToString();
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

        public static DBSQLGenEntity GetDBSQLByID(string name, string subName)
        {
            DBSQLGenEntity item = null;
            try
            {
                string sqlCommand = String.Format("select * from dbsql where name ='{0}' and subName ='{1}'", name, subName);
                DataTable dataTable = MySqlHelper.ExecuteDataset(sConnection, sqlCommand).Tables[0];
                if (null != dataTable && dataTable.Rows.Count > 0)
                {
                    item = new DBSQLGenEntity();
                    foreach (DataRow row in dataTable.Rows)
                    {
                        item.Id = Convert.ToInt32(row["id"]);
                        item.Name = row["name"].ToString();
                        item.SubName = row["subName"].ToString();
                        item.DBName = row["dbname"].ToString();
                        item.TableName = row["tablename"].ToString();
                        item.SQLText = row["sqltext"].ToString();
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


        public static int AddDBSQLGen(DBSQLGenEntity DBSQLGenEntity)
        {
            int result = 0;
            try
            {
                string sqlCommand = string.Format("insert into dbsql (name,subName, dbname,tablename,sqltext, datetime) values ( '{0}','{1}','{2}','{3}','{4}','{5}')",
                    DBSQLGenEntity.Name, DBSQLGenEntity.SubName,
                    DBSQLGenEntity.DBName, DBSQLGenEntity.TableName, DBSQLGenEntity.SQLText, DateTime.Now);
                result = MySqlHelper.ExecuteNonQuery(sConnection, sqlCommand);
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return result;
        }

        public static int UpdateDBSQLGen(DBSQLGenEntity DBSQLGenEntity)
        {
            int result = 0;
            try
            {
                string sqlCommand = string.Format("update dbsql set name='{0}',subName='{1}',dbname='{2}',tablename='{3}',sqltext='{4}', datetime='{5}' where id = {6}",
                    DBSQLGenEntity.Name, DBSQLGenEntity.SubName,
                   DBSQLGenEntity.DBName, DBSQLGenEntity.TableName, DBSQLGenEntity.SQLText, DateTime.Now, DBSQLGenEntity.Id);
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
