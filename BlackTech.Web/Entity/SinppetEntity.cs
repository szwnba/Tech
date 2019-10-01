using System;
using System.Collections.Generic;

namespace BlackTech.API.Entity.SnippetEntity
{

    public class SnippetEntity
    {
        public int Id { get; set; }
        public string Language { get; set; }
        public string CataType { get; set; }
        public string Casename { get; set; }
        public string Remark { get; set; }
        public string Datetime { get; set; }
     
    }
}