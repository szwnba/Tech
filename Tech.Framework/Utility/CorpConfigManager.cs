using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml;

namespace Tech.Framework.Utility
{
    public class CorpConfigManager
    {

        public static Hashtable GetConfigMessage()
        {
            Hashtable ht = null;
            //获取配置文件指定的Hashtable
            //Hashtable ht = xxxx.Automation.Framework.Lib.Xml.GetSettings();
            return ht;
        }

        public static string getConfigURL(string key)
        {
            string url = string.Empty;
            Hashtable ht = GetConfigMessage();
            url = (string)ht[key];
            return url;
        }
    }
}
