using Ctrip.Automation.Framework.Lib;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using MySql.Data.MySqlClient;

namespace Tech.Web.Common
{
    public class MySqlDBHelper
    {

        #region Common DB method


        /// <summary>
        /// Get ALll TABLE NAME
        /// </summary>
        /// <returns></returns>
        public static List<string> ShowDBNames(string connectionString)
        {
            List<string> tableNameList = new List<string>();
            string sqlCommand = string.Format("show databases",GetDBNameFromConnectionString(connectionString));
            DataTable dataTable = MySqlHelper.ExecuteDataset(connectionString, sqlCommand).Tables[0];
            if (null != dataTable && dataTable.Rows.Count > 0)
            {
                foreach (DataRow row in dataTable.Rows)
                {
                    tableNameList.Add(row[0].ToString());
                }
            }
            return tableNameList;
        }

        /// <summary>
        /// Get ALll TABLE NAME
        /// </summary>
        /// <returns></returns>
        public static DataTable GetTableName(string connectionString)
        {
            List<string> tableNameList = new List<string>();


            string sqlCommand = string.Format("SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = '{0}' and TABLE_NAME not like '_del%'  and TABLE_NAME not like '_bak%'",
                GetDBNameFromConnectionString(connectionString));
            DataTable dataTable = MySqlHelper.ExecuteDataset(connectionString, sqlCommand).Tables[0];

            return dataTable;
        }


        /// <summary>
        /// Get ALll TABLE Detail
        /// </summary>
        /// <returns></returns>
        public static DataTable GetTableDetail(string connectionString, string table)
        {
            string sqlCommand = string.Format("SELECT * from {0} order by 1 desc limit 500",table);
            DataTable dataTable = MySqlHelper.ExecuteDataset(connectionString, sqlCommand).Tables[0];
            return dataTable;
        }

        /// <summary>
        /// Get ALll TABLE Detail
        /// </summary>
        /// <returns></returns>
        public static DataTable GetTableDetailBySQL(string connectionString,string sql)
        {
            DataTable dataTable = MySqlHelper.ExecuteDataset(connectionString, sql).Tables[0];
            return dataTable;
        }


        /// <summary>
        /// Get TABLE  COLUMN NAME
        /// </summary>
        /// <returns></returns>
        public static List<Column> GetColumnName(string connectionString, string tablename)
        {
            List<Column> columnNameList = new List<Column>();

            try
            {
                string sqlCommand = string.Format("SELECT COLUMN_NAME,DATA_TYPE FROM information_schema.columns WHERE TABLE_SCHEMA = '{0}' and table_name = '{1}'", GetDBNameFromConnectionString(connectionString), tablename);
                DataTable dataTable = MySqlHelper.ExecuteDataset(connectionString, sqlCommand).Tables[0];
                if (null != dataTable && dataTable.Rows.Count > 0)
                {
                    foreach (DataRow row in dataTable.Rows)
                    {
                        Column column = new Column();
                        column.Name = row[0].ToString();
                        column.DataType = row[1].ToString();
                        columnNameList.Add(column);
                    }
                }
  
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return columnNameList;

        }

        public static string GenerateClassFromDB(string connectionString, string tablename)
        {
            try
            {
                List<Column> columns = GetColumnName(connectionString, tablename);
                StringBuilder content = new StringBuilder();
                content.AppendLine("    /// <summary>");
                content.AppendLine("    /// " + UpperFirstLetter(tablename));
                content.AppendLine("    /// </summary>");
                content.AppendLine("    public class " + UpperFirstLetter(tablename));
                content.AppendLine("    {");
                for (int j = 0; j < columns.Count; j++)
                {
                    content.AppendLine("        public " + CovertDataType(columns[j].DataType) + " " + columns[j].Name + " { get; set; }");
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

        public static string UpperFirstLetter(string tablename)
        {
            string firstLetter = tablename.Substring(0, 1).ToUpper();
            return firstLetter + tablename.Substring(1);
        }

        public static string LowerFirstLetter(string tablename)
        {
            string firstLetter = tablename.Substring(0, 1).ToLower();
            return firstLetter + tablename.Substring(1);
        }
        
        public static string CovertDataType(string dataType)
        {
            string result = "string";
            switch (dataType)
            {
                case "double":
                    result = "double";
                    break;
                case "float":
                    result = "float";
                    break;
                case "decimal":
                case "money":
                    result = "decimal";
                    break;
                case "datetime":
                    result = "DateTime";
                    break;
                case "bigint":
                    result = "long";
                    break;
                case "int":
                case "smallint":
                case "tinyint":
                    result = "int";
                    break;
                default:
                    result = "string";
                    break;
            }
            return result;
        }
        #endregion
    }


    public class Column
    {
        public string Name { get; set; }
        public string DataType { get; set; }
    }



}
