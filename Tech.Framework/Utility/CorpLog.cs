
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Tech.Framework.Utility
{
    public class SupperLog
    {
        public static void Attach(string name, string xml)
        {           
            try
            {
                //WriteTxt(name, xml);
                //TestLog.Attach(Attachment.CreateXmlAttachment(name, xml));
            }
            catch
            {
                //Log.Info("Attach xml file failed. Exception=" + ex.Message);
            }
        }

        public static void WriteTxt(string name, string xml)
        {
            try
            {
                System.IO.DirectoryInfo directoryInfo = System.IO.Directory.GetParent(System.Environment.CurrentDirectory).Parent;
                //StreamWriter sw = new StreamWriter(directoryInfo.FullName + string.Format("\\Log\\{0}.txt", name));
                StreamWriter sw = new StreamWriter(string.Format("\\\\dst89404\\Log\\{0}.txt", name));
                
                sw.Write(xml);
                sw.Close();
            }
            catch (Exception e)
            {
                //Log.Info("Catch exception. Exception=" + e.Message);
            }
        }
    }
}
