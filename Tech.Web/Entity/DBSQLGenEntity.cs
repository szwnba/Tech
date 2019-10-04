using System;
using System.Collections.Generic;

namespace Tech.Entity.DBSQLGenEntity
{

    public class DBSQLGenEntity
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public string SubName { get; set; }
        public string DBName { get; set; }
        public string TableName { get; set; }
        public string SQLText { get; set; }
        public string Datetime { get; set; }
     
    }
}