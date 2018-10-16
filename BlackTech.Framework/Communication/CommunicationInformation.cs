using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Collections;
using System.Xml.Serialization;

namespace BlackTech.Framework.Communication
{
    public class CommunicationInformation
    {
        public String URI;
        public MsgProtocol MessageProtocol; // soap | Interop
        public MessageFormat.MessageContentType ContentType; // xml | fastinfoset | json
        public HTTPSendMode HttpSendMode;
        public String SOAPAction;
        public XmlSerializerNamespaces NameSpaces;
        public bool NeedSoap;
        public MessageEncodeDecode.MessageContentEncoding ContentEncoding; // gzip
        public Encoding encode; //UTF-8

        public enum HTTPSendMode
        {
            GET,
            POST
        }

        public CommunicationInformation(String uri, MsgProtocol protocol = MsgProtocol.Interop, MessageFormat.MessageContentType contentType = MessageFormat.MessageContentType.FastInfoSet,
         HTTPSendMode httpSendMode = HTTPSendMode.POST, String soapAction = null, XmlSerializerNamespaces nameSpaces = null, bool needSoap = false, MessageEncodeDecode.MessageContentEncoding contentEncoding = MessageEncodeDecode.MessageContentEncoding.None, Encoding encode = null)
        {
            this.URI = uri;
            this.MessageProtocol = protocol;
            this.ContentType = contentType;
            this.HttpSendMode = httpSendMode;
            this.SOAPAction = soapAction;
            this.NameSpaces = nameSpaces;
            this.NeedSoap = needSoap;
            this.ContentEncoding = contentEncoding;
            this.encode = (null == encode) ? Encoding.UTF8 : encode;
        }
    }
}
