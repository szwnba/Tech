using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml;
using System.Xml.Serialization;

namespace BlackTech.Framework.Utility
{
    public static class TypeTransferHelper
    {
        public static String ObjToStr(Object message)
        {
            String reqRespContent = "";
            try
            {
                XmlWriterSettings settings = new XmlWriterSettings();
                settings.Indent = true;
                settings.Encoding = Encoding.UTF8;
                StringBuilder sb = new StringBuilder();
                XmlSerializer ser = new XmlSerializer(message.GetType());
                XmlWriter writer = XmlWriter.Create(sb, settings);
                ser.Serialize(writer, message);
                reqRespContent = sb.ToString();
                reqRespContent = reqRespContent.Substring(41);
            }
            catch (Exception ex)
            {
                //Log.Info("Catch exception when transfer from obj to str. Exception=" + ex.Message);
            }

            return reqRespContent;
        }

        public static Object strToObj(string strContext, Type objectType, Encoding encode = null)
        {
            object obj = null;
            try
            {
                XmlSerializerFactory xmlSerializerFactory = new XmlSerializerFactory();
                XmlSerializer xmlSerializer =
                    xmlSerializerFactory.CreateSerializer(objectType, objectType.Name);
                byte[] byteArray;
                if (encode == Encoding.GetEncoding("GB2312"))
                    byteArray = Encoding.GetEncoding("GB2312").GetBytes(strContext);
                else
                    byteArray = Encoding.UTF8.GetBytes(strContext);
                MemoryStream ms = new MemoryStream(byteArray);

                obj = xmlSerializer.Deserialize(ms);
                ms.Close();
            }
            catch (Exception ex)
            {
                //Log.Info("Catch exception when transfer from str to obj. Exception=" + ex.Message);
            }

            return obj;
        }

        public static MemoryStream StreamToMemoryStream(Stream stream, Encoding encode = null)
        {
            if (stream == null)
            {
                //Log.Info("Inputed stream is null.");
                throw new ArgumentNullException("Inputed stream is null.");
            }

            MemoryStream memoryStream = new MemoryStream();
            byte[] byteArray = StreamToByteArray(stream);
            if (byteArray == null)
            {
                //Log.Info("Inputed byteArray is null.");
                throw new ArgumentNullException("Inputed byteArray is null.");
            }

            var binaryWriter = new BinaryWriter(memoryStream, (null == encode) ? Encoding.UTF8 : encode);
            binaryWriter.Write(byteArray);

            return memoryStream;
        }

        public static byte[] StreamToByteArray(Stream stream)
        {
            if (stream == null)
            {
                //Log.Info("Inputed stream is null.");
                throw new ArgumentNullException("Inputed stream is null.");
            }

            using (MemoryStream ms = new MemoryStream())
            {
                stream.CopyTo(ms);
                return ms.ToArray();
            }
        }

        public static MemoryStream ConvertStrToMemoryStream(string str)
        {
            if (str == null)
            {
                //Log.Info("Inputed str is null.");
                throw new ArgumentNullException("Inputed str is null.");
            }
            byte[] byteArray = Encoding.Default.GetBytes(str);
            MemoryStream ms = new MemoryStream();
            ms.Write(byteArray, 0, byteArray.Length);

            return ms;
        }

        public static MemoryStream ConvertXmlNodeToMemoryStream(XmlNode node, Encoding encode = null)
        {
            if (node == null)
            {
                //Log.Info("Inputed node is null.");
                throw new ArgumentNullException("Inputed node is null.");
            }
            byte[] byteArray;
            if (encode == Encoding.GetEncoding("GB2312"))
            {
                byteArray = Encoding.GetEncoding("GB2312").GetBytes(node.InnerXml);
            }
            else if(encode == Encoding.GetEncoding("UTF-8"))
                byteArray = Encoding.GetEncoding("UTF-8").GetBytes(node.InnerXml);
            else
                byteArray = Encoding.ASCII.GetBytes(node.InnerXml);

            MemoryStream ms = new MemoryStream();
            ms.Write(byteArray, 0, byteArray.Length);

            return ms;
        }

        public static string ConvertMemoryStreamToStr(MemoryStream ms, Encoding encode = null)
        {
            string str = string.Empty;
            byte[] a = ms.ToArray();
            if (encode == Encoding.GetEncoding("GB2312"))
            {
                str = Encoding.GetEncoding("GB2312").GetString(a);
            }
            else
            { 
                str = Encoding.UTF8.GetString(a); 
            }
            
            return str;
        }

        #region Convert Json data -> XmlDocument and XmlDocument -> Json data
        public static XmlDocument convertStrJsonDataToXmlDoc(string strJsonData, string rootName = null)
        {
            if (!string.IsNullOrEmpty(strJsonData))
            {
                if (rootName == null) return Newtonsoft.Json.JsonConvert.DeserializeXmlNode(strJsonData);
                else return JsonConvert.DeserializeXmlNode(strJsonData, rootName);
            }
            else
                return null;
        }

        public static string convertXmlDocToStrJsonData(XmlDocument xmlDoc, bool omitRootObject = false)
        {
            string strDoc = JsonConvert.SerializeXmlNode(xmlDoc, Newtonsoft.Json.Formatting.None, omitRootObject);
            return strDoc;
        }

        /// <summary>
        /// 转换对象为JSON格式的字符串
        /// </summary>
        /// <typeparam name="T">类型</typeparam>
        /// <param name="obj">对象</param>
        /// <returns>返回JSON格式的字符串</returns>
        public static string ToJson<T>(this T obj) where T : class
        {
            string result = String.Empty;
            try
            {
                JsonSerializerSettings jsetting = new JsonSerializerSettings();
                jsetting.DefaultValueHandling = DefaultValueHandling.Ignore;
                result = JsonConvert.SerializeObject(obj, jsetting);
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return result;
        }

        /// <summary>
        /// JSON格式字符转换为T类型的对象
        /// </summary>
        /// <typeparam name="T">类型</typeparam>
        /// <param name="jsonStr">JSON格式的字符串</param>
        /// <returns>返回<typeparamref name="T"/>对象</returns>
        public static T ToObject<T>(this string jsonStr) where T : class
        {
            T json = default(T);
            try
            {
                json = JsonConvert.DeserializeObject<T>(jsonStr);
            }
            catch (Exception ex)
            {

                throw ex;
            }
            return json;
        }
        #endregion
    }
}
