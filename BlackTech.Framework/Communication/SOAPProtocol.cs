using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Xml;
using System.IO;
using System.Net;
using BlackTech.Framework.Utility;

namespace BlackTech.Framework.Communication
{
    public class SOAPProtocol
    {
        public static MemoryStream GetSOAPBody(MemoryStream bodyContent, Encoding encode = null)
        {
            if (bodyContent == null)
                throw new ArgumentNullException("bodyContent");

            XmlNode body = GetSOAPBodyNode(bodyContent);
            MemoryStream ms = TypeTransferHelper.ConvertXmlNodeToMemoryStream(body, encode);

            return ms;
        }

        public static XmlNode GetSOAPBodyNode(MemoryStream bodyContent)
        {
            if (bodyContent == null)
                throw new ArgumentNullException("bodyContent");

            XmlDocument doc = new XmlDocument();

            if (bodyContent.CanSeek)
                bodyContent.Position = 0;

            doc.Load(bodyContent);

            XmlNode root = doc.FirstChild;
            if (root != null &&
                root.NodeType == XmlNodeType.XmlDeclaration)
            {
                root = root.NextSibling;
            }

            if (root == null)
                throw new ApplicationException("Root element node is missing in XmlDocument");

            XmlNode rspbody = root["soap:Body"];
            if (rspbody == null)
                throw new ApplicationException("Body element node is missing in XmlDocument");

            return rspbody;
        }

        public static MemoryStream CreateSoapRequest(MemoryStream bodyContent, CommunicationInformation commInfo)
        {
            if (bodyContent == null)
                throw new ArgumentNullException("bodyContent");
            if (commInfo == null)
                throw new ArgumentNullException("commInfo");

            XmlDocument doc = CreateSOAPRequest(bodyContent);

            MemoryStream ms = TypeTransferHelper.ConvertStrToMemoryStream(doc.InnerXml);

            return ms;
        }

        public static XmlDocument CreateSOAPRequest(MemoryStream bodyContent)
        {
            XmlDocument doc = new XmlDocument();
            string xmlStr = "" + //"<?xml version='1.0' encoding='utf-8'?>\r\n" +
            "<soapenv:Envelope " +
            "xmlns:soapenv='http://schemas.xmlsoap.org/soap/envelope/' " +
            "xmlns:xxxx='http://www.xxxx.com/webservice/xxxx/' " +
            "xmlns:flig='http://www.xxxx.com/webservice/flight/'>\r\n" +
            "</soapenv:Envelope>";
            doc.LoadXml(xmlStr);

            //Get root element
            XmlElement envelope = doc.DocumentElement;

            //Create header
            XmlElement header = doc.CreateElement("soapenv", "Header", "http://schemas.xmlsoap.org/soap/envelope/");

            // Append header to envelope
            envelope.AppendChild(header);

            //Create body
            XmlElement body = doc.CreateElement("soapenv", "Body", "http://schemas.xmlsoap.org/soap/envelope/");

            bodyContent.Seek(0, SeekOrigin.Begin);
            StreamReader reader = new StreamReader(bodyContent); 
            body.InnerXml = reader.ReadToEnd();

            envelope.AppendChild(body);

            return doc;
        }
    }
}
