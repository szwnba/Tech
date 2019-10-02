using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using System.Web;
using System.Xml;

namespace Tech.Web.Util
{

    public class FileHelper
    {
   
        /// <summary>
        /// 输入指定内容到本地
        /// </summary>
        /// <param name="output"></param>
        public static void OutputLog(string filename, string output)
        {
            System.IO.StreamWriter swOut = new System.IO.StreamWriter(@"F:\" + filename + ".txt", true, System.Text.Encoding.Default);
            swOut.WriteLine(output);
            swOut.Flush();
            swOut.Close();
        }

        public static List<string> GetFileList(string path)
        {
            //string path = HttpContext.Current.Server.MapPath("~/resources/Xml");
            List<string> fileList = new List<string>();
            DirectoryInfo root = new DirectoryInfo(path);
            FileInfo[] fileInfos = root.GetFiles();

            foreach (FileInfo fileInfo in fileInfos)
            {
                string filename = fileInfo.Name.Split('.')[0];
                fileList.Add(filename);
            }

            return fileList;
        }
    }
}