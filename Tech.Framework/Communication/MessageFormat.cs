using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.IO;
using System.Xml;
using System.Xml.Serialization;
using Noemax.FastInfoset;
using System.Runtime.Serialization.Formatters.Binary;
using System.Reflection;
using Tech.Framework.Utility;

namespace Tech.Framework.Communication
{
    public class MessageFormat
    {
        public enum MessageContentType
        {
            Xml,
            FastInfoSet,
            Json,
            Form
        };

        static public MemoryStream Serialize(MemoryStream ms, MessageContentType msgContentType)
        {
            if (ms == null)
            {
                //Log.Info("ms is null.");
                throw new Exception("ms is null.");
            }

           if (msgContentType == MessageContentType.FastInfoSet)
                return FastInfoSetSerializer.Serialize(ms);
            else
                return ms;
        }

        static public MemoryStream Deserialize(MemoryStream ms, MessageContentType msgContentType)
        {
            if (msgContentType == MessageContentType.FastInfoSet)
                return FastInfoSetSerializer.DeSerialize(ms);
            else
                return ms;
        }
    }

    public class XMLSerializer
    {
        public static XmlWriterSettings GetDefaultXmlWriterSettings(bool Readable = true)
        {
            XmlWriterSettings settings = new XmlWriterSettings();
            settings.Encoding = new UTF8Encoding(true);
            settings.ConformanceLevel = ConformanceLevel.Document;
            settings.Indent = Readable;
            if (Readable)
                settings.IndentChars = "    ";
            settings.NewLineOnAttributes = Readable;
            settings.OmitXmlDeclaration = true;
            return settings;
        }

        // Conversion from Object to XML
        public static MemoryStream Serialize(object inputObject, Type inputObjectType, MessageFormat.MessageContentType msgContentType, XmlSerializerNamespaces nameSpaces)
        {
            if (inputObject == null)
            {
                //Log.Info("inputObject is null.");
                throw new Exception("inputObject is null.");
            }

            if (inputObjectType == null)
            {
                //Log.Info("inputObjectType is null.");
                throw new Exception("inputObjectType is null.");
            }
            if (msgContentType == MessageFormat.MessageContentType.Json || msgContentType == MessageFormat.MessageContentType.Form)
            {
                    return TypeTransferHelper.ConvertStrToMemoryStream(TypeTransferHelper.ObjToStr(inputObject));
            }

            MemoryStream msSerialized = new MemoryStream();
            using (XmlWriter writer = XmlTextWriter.Create(msSerialized, GetDefaultXmlWriterSettings()))
            {
                XmlSerializer xs = new XmlSerializer(inputObjectType);
                xs.Serialize(writer, inputObject, nameSpaces);
                writer.Flush();
                writer.Close();
            }

            msSerialized.Seek(0, SeekOrigin.Begin);
            return msSerialized;
        }

        //Conversion from XML to object
        public static object DeSerialize(MemoryStream msSerialized, Type outputObjectType, MessageFormat.MessageContentType msgContentType, Encoding encode = null)
        {
            if (msSerialized == null)
            {
                //Log.Info("msSerialized is null.");
                throw new Exception("msSerialized is null.");
            }

            if (outputObjectType == null)
            {
                //Log.Info("outputObjectType is null.");
                throw new Exception("outputObjectType is null.");
            }

            if (msgContentType == MessageFormat.MessageContentType.Json || msgContentType == MessageFormat.MessageContentType.Form)
            {
                string str = TypeTransferHelper.ConvertMemoryStreamToStr(msSerialized, encode);
                return TypeTransferHelper.strToObj(str, outputObjectType);
            }

            object outputObject = null;
            msSerialized.Seek(0, SeekOrigin.Begin);
            using (XmlReader reader = XmlTextReader.Create(msSerialized))
            {
                if (null != reader)
                {
                    XmlSerializer serializer = new XmlSerializer(outputObjectType);
                    outputObject = serializer.Deserialize(reader);
                }
            }

            return outputObject;
        }

    }

    public class FastInfoSetSerializer
    {
        public static MemoryStream Serialize(MemoryStream ms)
        {
            if (ms == null)
            {
                //Log.Info("ms is null.");
                throw new Exception("ms is null.");
            }

            MemoryStream msFastInfoset = new MemoryStream();

            ms.Seek(0, SeekOrigin.Begin);
            using (XmlTextReader reader = new XmlTextReader(ms))
            {
                XmlWriterSettings settings = XMLSerializer.GetDefaultXmlWriterSettings();
                using (XmlFastInfosetWriter writer = (XmlFastInfosetWriter)XmlFastInfosetWriter.Create(msFastInfoset, settings))
                {
                    reader.Read();
                    if (reader.NodeType == XmlNodeType.XmlDeclaration)
                        reader.Read();
                    writer.WriteStartDocument();
                    while (reader.NodeType != XmlNodeType.None)
                        writer.WriteNode(reader, false);
                    writer.WriteEndDocument();
                    writer.Flush();
                    writer.Close();
                }
            }

            return msFastInfoset;
        }

        public static MemoryStream DeSerialize(MemoryStream ms)
        {
            if (ms == null)
            {
                //Log.Info("ms is null.");
                throw new Exception("ms is null.");
            }

            ms.Seek(0, SeekOrigin.Begin);
            XmlDocument doc = new XmlDocument();
            using (XmlReader reader = XmlFastInfosetReader.Create(ms))
            {
                doc.Load(reader);
            }

            MemoryStream msDeserialized = new MemoryStream();
            using (XmlWriter writer = XmlWriter.Create(msDeserialized))
            {
                doc.WriteContentTo(writer);
                writer.Flush();
                writer.Close();
            }

            msDeserialized.Seek(0L, SeekOrigin.Begin);
            return msDeserialized;
        }

        //Deserialize fastinfoset logged in DB
        public static object DeserializeFIInDB(byte[] encodedData, Type objectType)
        {
            MemoryStream ms = new MemoryStream(encodedData);
            Object obj;
            obj = FastInfoSetSerializer.DeSerialize(ms, objectType);

            return obj;
        }

        //Direct one step conversion from FI to the object.        
        public static object DeSerialize(MemoryStream ms, Type ObjectType)
        {
            // get a weakly typed DOM from Fast Infoset response (so DateTimes are just strings)
            XmlDocument xmlDoc = XMLDeSerialize(ms);
            // convert to strongly typed DOM
            XmlSerializer xmlSerializer = new XmlSerializer(ObjectType);
            MemoryStream ms2 = new MemoryStream();
            XmlWriter xmlw = XmlWriter.Create(ms2);
            xmlDoc.WriteContentTo(xmlw);
            xmlw.Flush();
            ms2.Seek(0L, SeekOrigin.Begin);
            XmlReader xmlr = XmlReader.Create(ms2);
            return xmlSerializer.Deserialize(xmlr);
        }

        //Deserialize from FastInfoset to DOM
        public static XmlDocument XMLDeSerialize(MemoryStream ms)
        {
            XmlDocument doc = new XmlDocument();
            if (ms.CanSeek) ms.Position = 0;
            using (XmlReader reader = XmlFastInfosetReader.Create(ms))
            {
                try
                {
                    doc.Load(reader);
                }
                catch (Exception ex)
                {
                    //Log.Info("Catch exception when Deserialize it from FI to DOM. Exception=" + ex.Message);
                    return null;
                }

            }
            return doc;
        }

        public static string ByteArrayToString(byte[] bytes)
        {
            System.Text.Encoding encoding = null;
            encoding = new System.Text.UTF8Encoding();

            return encoding.GetString(bytes);
        }

        /// <summary>
        /// Serilize the object to binary stream
        /// </summary>
        /// <param name="obj"></param>
        /// <returns></returns>
        public static byte[] ObjectToByteArray(Object obj)
        {
            if (obj == null)
                return null;
            BinaryFormatter bf = new BinaryFormatter();
            MemoryStream ms = new MemoryStream();
            bf.Serialize(ms, obj);
            return ms.ToArray();
        }
    }
}
