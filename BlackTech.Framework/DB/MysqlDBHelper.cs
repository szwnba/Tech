using BlackTech.Framework.Utility;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using MySql.Data.MySqlClient;


namespace BlackTech.Framework.DB
{
    public class MysqlDBHelper
    {

        #region Common DB method

        /// <summary>
        /// Get ALll TABLE NAME
        /// </summary>
        /// <returns></returns>
        public static List<string> GetTableName(string connectionString)
        {
            List<string> tableNameList = new List<string>();

            try
            {
                string sqlCommand =string.Format("SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = '{0}'",
                    GetDBNameFromConnectionString(connectionString));
                DataTable dataTable = MySqlHelper.ExecuteDataset(connectionString, sqlCommand).Tables[0];
                if (null != dataTable && dataTable.Rows.Count > 0)
                {
                    foreach (DataRow row in dataTable.Rows)
                    {
                        string name = row[0].ToString();
                        tableNameList.Add(name);
                    }
                }
                //else
                    //Log.Info("No record in  table.");
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return tableNameList;
        }

        /// <summary>
        /// Get TABLE  COLUMN NAME
        /// </summary>
        /// <returns></returns>
        public static List<string> GetColumnName(string connectionString, string tablename)
        {
            List<string> columnNameList = new List<string>();

            try
            {
                string sqlCommand = string.Format("SELECT COLUMN_NAME FROM information_schema.columns WHERE TABLE_SCHEMA = '{0}' and table_name = '{1}'",GetDBNameFromConnectionString(connectionString), tablename);
                DataTable dataTable = MySqlHelper.ExecuteDataset(connectionString, sqlCommand).Tables[0];
                if (null != dataTable && dataTable.Rows.Count > 0)
                {
                    foreach (DataRow row in dataTable.Rows)
                    {
                        string name = row[0].ToString();
                        columnNameList.Add(name);
                    }
                }
                //else
                    //Log.Info("No record in  table.");
            }
            catch (Exception ex)
            {
                //Log.Info("Catch exception when reading table. Exception=" + ex.Message);
            }
            return columnNameList;

        }

        public static string GenerateClassFromDB(string connectionString, string tablename)
        {
            try
            {
                List<string> columns = GetColumnName(connectionString,tablename);
                StringBuilder content = new StringBuilder();
                content.AppendLine("    /// <summary>");
                //content.AppendLine("    /// " + DBHelper.UpperFirstLetter(tablename));
                content.AppendLine("    /// </summary>");
                //content.AppendLine("    public class " + DBHelper.UpperFirstLetter(tablename));
                content.AppendLine("    {");
                for (int j = 0; j < columns.Count; j++)
                {
                    content.AppendLine("        public string " + columns[j] + " { get; set; }");
                }
                content.AppendLine("    }");

                return content.ToString();
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public static string GetDBNameFromConnectionString(string connectionString)
        {
            int firstIndex = connectionString.IndexOf("Database=");
            string part = connectionString.Substring(firstIndex + 9);
            int lastIndex = part.IndexOf(";");
            return part.Substring(0, lastIndex);
        }

        #endregion
    }
     
}
