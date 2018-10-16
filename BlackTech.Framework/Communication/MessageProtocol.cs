using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.IO;

namespace BlackTech.Framework.Communication
{
    public enum MsgProtocol
    {
        SOAP,
        Interop,
        Text
    };

    public class MessageProtocol
    {
        public static MemoryStream AttachProtocol(MemoryStream ms, CommunicationInformation commInfo)
        {
            if (commInfo.MessageProtocol == MsgProtocol.SOAP || commInfo.NeedSoap)
            {
                return SOAPProtocol.CreateSoapRequest(ms, commInfo);
            }
            else if (commInfo.MessageProtocol == MsgProtocol.Interop || commInfo.MessageProtocol == MsgProtocol.Text)
            {
                return ms; // There is no Header 
            }

            throw new ArgumentOutOfRangeException("commInfo.MessageProtocol");
        }

        public static MemoryStream DetachProtocol(MemoryStream ms, CommunicationInformation commInfo)
        {
            if (commInfo.MessageProtocol == MsgProtocol.SOAP || commInfo.NeedSoap)
            {
                return SOAPProtocol.GetSOAPBody(ms, commInfo.encode);
            }
            else if (commInfo.MessageProtocol == MsgProtocol.Interop || commInfo.MessageProtocol == MsgProtocol.Text)
            {
                return ms; // There is no Header 
            }

            throw new ArgumentOutOfRangeException("commInfo.MessageProtocol");
        }
    }
}
