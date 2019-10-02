using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Net;
using System.Xml;
using System.IO;
using System.Threading;
using System.Reflection;
using Tech.Framework.Utility;
using System.Diagnostics;
using System.Net.Security;
using System.Security.Authentication;
using System.Security.Cryptography.X509Certificates;

namespace Tech.Framework.Communication
{
    public class CommunicationManager
    {
        public enum MessageMode
        {
            Serialize,
            Deserialize
        }

        public static ResponseT send<RequestT, ResponseT>(RequestT reqObj, CommunicationInformation commInfo, Encoding encode = null, string requestName = null)
        {
            if (reqObj == null)
            {
                //Log.Info("Inputed reqObj is null.");
                throw new ArgumentNullException("Inputed reqObj is null.");
            }

            if (commInfo == null)
            {
                //Log.Info("Inputed commInfo is null.");
                throw new ArgumentNullException("Inputed commInfo is null.");
            }

            MemoryStream msReq = null;
            MemoryStream msRsp = null;

            if (commInfo.URI.StartsWith("https"))
                ServicePointManager.ServerCertificateValidationCallback = new System.Net.Security.RemoteCertificateValidationCallback(CheckValidationResult);

            //if (null == requestName)
            //    Log.Info("Request content:\r\n" + TypeTransferHelper.ObjToStr(reqObj));
            //else
                SupperLog.Attach(requestName + "Req_" + DateTime.Now.ToString("yyyyMMdd'T'HHmmssfff"), TypeTransferHelper.ObjToStr(reqObj));

            // Serialize Request [obj] to [objXML]
            msReq = XMLSerializer.Serialize(reqObj, typeof(RequestT), commInfo.ContentType, commInfo.NameSpaces);

            // Attach Protocol [objXML] to [Hdr + objXML]
            msReq = MessageProtocol.AttachProtocol(msReq, commInfo);

            // Serialize Request [Hdr + objXML] to [FI[Hdr + objXML]]
            msReq = MessageFormat.Serialize(msReq, commInfo.ContentType);

            ResponseT rspobj;
            string statusCode = "";
            HttpWebResponse httpWebResponse = SendReqAndRecvResp(msReq, commInfo, typeof(RequestT).Name);
            if (null != httpWebResponse)
            {
                statusCode = httpWebResponse.StatusCode.ToString();
                //Log.Info("StatusCode=" + statusCode);
            }

            msRsp = TypeTransferHelper.StreamToMemoryStream(httpWebResponse.GetResponseStream(), encode);

            // Decode Response [GZip[FI[Hdr + objXML]]] to [FI[Hdr + objXML]]
            msRsp = MessageEncodeDecode.Decode(msRsp, httpWebResponse.ContentEncoding.ToString());

            // DeSerialize Response [FI[Hdr + objXML]] to [Hdr + objXML]
            msRsp = MessageFormat.Deserialize(msRsp, commInfo.ContentType);

            // Detach Protocol [Hdr + objXML] to [objXML]
            msRsp = MessageProtocol.DetachProtocol(msRsp, commInfo);

            // Deserialize Response [objXML] to [obj]
            rspobj = (ResponseT)XMLSerializer.DeSerialize(msRsp, typeof(ResponseT), commInfo.ContentType, encode);

            //if (null == requestName)
            //    Log.Info("Response content:\r\n" + TypeTransferHelper.ConvertMemoryStreamToStr(msRsp, encode));
            //else
                SupperLog.Attach(requestName + "Resp_" + DateTime.Now.ToString("yyyyMMdd'T'HHmmssfff") + new Random().Next(0, 100), TypeTransferHelper.ConvertMemoryStreamToStr(msRsp, encode));
            return rspobj;
        }

        public static HttpWebResponse SendReqAndRecvResp(MemoryStream ms, CommunicationInformation commInfo, string requestTypeName = null)
        {
            if (null == ms)
            {
                //Log.Info("Inputed ms is null.");
                throw new ArgumentNullException("Inputed ms is null.");
            }

            if (commInfo == null)
            {
                //Log.Info("Inputed commInfo is null.");
                throw new ArgumentNullException("Inputed commInfo is null.");
            }

            HttpWebRequest httpWebRequest = CreateRequestHeader(commInfo);

            httpWebRequest.ContentLength = ms.GetBuffer().Length;
            httpWebRequest.GetRequestStream().Write(ms.GetBuffer(), 0, ms.GetBuffer().Length);
            return SendRequestAndReceiveResponse(httpWebRequest);
        }

        public static HttpWebResponse SendRequestAndReceiveResponse(HttpWebRequest request)
        {
            HttpWebResponse response = null;
            if (request == null)
            {
                //Log.Info("Inputed request is null.");
                throw new ArgumentNullException("Inputed request is null.");
            }

            try
            {
                Stopwatch stopWatch = new Stopwatch();
                stopWatch.Start();
                response = (HttpWebResponse)request.GetResponse();
                stopWatch.Stop();
                //Log.Info(string.Format("ResponseTime={0}s", stopWatch.ElapsedMilliseconds/1000.00));
            }
            catch (Exception e)
            {
                throw e;
            }
            return response;
        }

        public static HttpWebRequest CreateRequestHeader(CommunicationInformation commInfo)
        {
            HttpWebRequest request = null;
            request = (HttpWebRequest)WebRequest.Create(commInfo.URI);
            request.Pipelined = false;
            request.Method = commInfo.HttpSendMode.ToString();
            request.KeepAlive = true;
            request.Timeout = 150000;
            request.ContentType = getContentType(commInfo.ContentType, commInfo.MessageProtocol);
            //Log.Info("ContentType=" + request.ContentType);
            if (!string.IsNullOrEmpty(commInfo.SOAPAction))
                request.Headers.Add("SOAPAction", commInfo.SOAPAction);

            //request.UserAgent = "Mozilla/5.0 (Windows NT 6.1; WOW64; Trident/7.0; rv:11.0) like Gecko";

            return request;
        }

        public static string getContentType(MessageFormat.MessageContentType messageContentType = MessageFormat.MessageContentType.Xml,
            MsgProtocol msgProtocol = MsgProtocol.Interop)
        {
            string contentType = "application/";
            if (msgProtocol == MsgProtocol.SOAP)
            {
                contentType += "soap+";
            }
            else if (msgProtocol == MsgProtocol.Text)
            {
                contentType = "text/";
            }

            switch (messageContentType)
            {
                case MessageFormat.MessageContentType.Xml:
                    contentType += "xml; charset=UTF-8";
                    break;
                case MessageFormat.MessageContentType.FastInfoSet:
                    contentType += "fastinfoset";
                    break;
                case MessageFormat.MessageContentType.Json:
                    contentType += "json";
                    break;
                case MessageFormat.MessageContentType.Form:
                    contentType += "x-www-form-urlencoded; charset=UTF-8";
                    break;
                default:
                    {
                        //Log.Info("Inputed ContentType is unsupported. ContentType=" + messageContentType.ToString());
                        throw new ArgumentOutOfRangeException("Inputed ContentType is unsupported. ContentType=" + messageContentType.ToString());
                    }
            }
            return contentType;
        }

        public static string send(string strRequest, CommunicationInformation comInfo, Encoding encode = null, string requestName = "")
        {
            if (strRequest == null)
            {
                //Log.Info("Input parameter requestObj is null.");
                throw new ArgumentNullException("Input parameter requestObj is null.");
            }

            if (comInfo == null)
            {
                //Log.Info("Input parameter comInfo is null.");
                throw new ArgumentNullException("Input parameter comInfo is null.");
            }

            if (comInfo.URI.StartsWith("https"))
                ServicePointManager.ServerCertificateValidationCallback = new System.Net.Security.RemoteCertificateValidationCallback(CheckValidationResult);

            // Attach Protocol str Request  1. convert str to MemoryStream 2. add soap envelop 3. convert MemoryStream to String
            if (comInfo.HttpSendMode == CommunicationInformation.HTTPSendMode.POST)
            {
                MemoryStream stream = new MemoryStream();
                StreamWriter writer = new StreamWriter(stream);
                writer.Write(strRequest);
                writer.Flush();
                stream = MessageProtocol.AttachProtocol(stream, comInfo);
                stream.Position = 0;
                StreamReader readerReq = new StreamReader(stream);
                strRequest = readerReq.ReadToEnd();
                readerReq.Close();
            }

            WebRequest request = WebRequest.Create(comInfo.URI);
            request.Timeout = 600000;
            request.Method = comInfo.HttpSendMode.ToString();
            request.ContentType = getContentType(comInfo.ContentType, comInfo.MessageProtocol);
            request.Headers.Add("Accept-Language", "zh-CN,zh;q=0.8,en-US;q=0.5,en;q=0.3");
            if (comInfo.SOAPAction != null)
            {
                request.Headers.Add("SOAPAction", comInfo.SOAPAction);
            }

            //if (null == requestName)
            //    Log.Info("Request content:\r\n" + strRequest);
            //else
                SupperLog.Attach(requestName + "Req_" + DateTime.Now.ToString("yyyyMMdd'T'HHmmssfff"), strRequest);

            Stream dataStream = null;
            if (comInfo.HttpSendMode == CommunicationInformation.HTTPSendMode.POST)
            {
                byte[] byteArray = Encoding.UTF8.GetBytes(strRequest);
                request.ContentLength = byteArray.Length;

                // Get the request stream.
                dataStream = request.GetRequestStream();
                // Write the data to the request stream.
                dataStream.Write(byteArray, 0, byteArray.Length);

                // Close the Stream object.
                dataStream.Close();
            }

            // Get the response.
            WebResponse response = request.GetResponse();
            // Display the status.
            //Log.Info("Response.StatusDescription=" + ((HttpWebResponse)response).StatusDescription);
            // Get the stream containing content returned by the server.
            string strResponse = string.Empty;

            dataStream = response.GetResponseStream();
            //dataStream = MessageProtocol.DetachProtocol(response., comInfo);
            // Open the stream using a StreamReader for easy access.
            StreamReader reader = new StreamReader(dataStream, (null == encode) ? Encoding.UTF8 : encode);
            // Read the content.
            strResponse = reader.ReadToEnd();

            // Detach Protocol str response if it send with soap env
            MemoryStream streamRsp = new MemoryStream();
            StreamWriter writerRsp = new StreamWriter(streamRsp);
            writerRsp.Write(strResponse);
            writerRsp.Flush();
            streamRsp = MessageProtocol.DetachProtocol(streamRsp, comInfo);
            streamRsp.Position = 0;
            StreamReader readerRsp = new StreamReader(streamRsp, (null == encode) ? Encoding.UTF8 : encode);
            strResponse = readerRsp.ReadToEnd();
            readerRsp.Close();

            // Display the content.
            //if (null == requestName)
            //    Log.Info("Response content:\r\n" + strResponse);
            //else
            //{
            //    if (comInfo.ContentType == MessageFormat.MessageContentType.Json && strResponse.StartsWith("["))
            //        strResponse = "{\"CityInfo\":" + strResponse + "}";
            //    CorpLog.Attach(requestName + "Resp_" + DateTime.Now.ToString("yyyyMMdd'T'HHmmssfff"), (comInfo.ContentType == MessageFormat.MessageContentType.Json) ? TypeTransferHelper.convertStrJsonDataToXmlDoc(strResponse, "json").OuterXml : strResponse);
            //}
            // Clean up the streams.
            reader.Close();
            dataStream.Close();
            response.Close();
            return strResponse;
        }

        public static string sendGet(string url, bool isLogRsp = true,string proxy ="")
        {
            if (url.StartsWith("https"))
                ServicePointManager.ServerCertificateValidationCallback = new System.Net.Security.RemoteCertificateValidationCallback(CheckValidationResult);
            WebRequest request = WebRequest.Create(url);
         
            request.Method = CommunicationInformation.HTTPSendMode.GET.ToString();
            request.Timeout = 3000;
            // Get the response.
            WebResponse response = request.GetResponse();
            // Display the status.
            //Log.Info("Response.StatusDescription=" + ((HttpWebResponse)response).StatusDescription);
            // Get the stream containing content returned by the server.
            string strResponse = string.Empty;
            Stream dataStream = response.GetResponseStream();
            // Open the stream using a StreamReader for easy access.
            StreamReader reader = new StreamReader(dataStream, Encoding.UTF8);
            // Read the content.
            strResponse = reader.ReadToEnd();
            // Display the content.
            //if (isLogRsp) Log.Info("Response content:\r\n" + strResponse);
            // Clean up the streams.
            reader.Close();
            dataStream.Close();
            response.Close();
            return strResponse;
        }


        public static bool checkProxy( string proxy = "")
        {
            string url = "http://www.163.com";
            if (url.StartsWith("https"))
                ServicePointManager.ServerCertificateValidationCallback = new System.Net.Security.RemoteCertificateValidationCallback(CheckValidationResult);
            WebRequest request = WebRequest.Create(url);
            if (proxy != "")
            {
                List<string> iplist= proxy.Split(':').ToList();
                string host = iplist[0];
                int port= Convert.ToInt32(iplist[1]);
                System.Net.WebProxy wp = new System.Net.WebProxy(host, port);
                //wp.Credentials = new System.Net.NetworkCredential("username", "password");
                request.Proxy = wp;
            }
            request.Method = CommunicationInformation.HTTPSendMode.GET.ToString();
            request.Timeout = 10000;
            // Get the response.
            WebResponse response = request.GetResponse();
            // Display the status.
            //Log.Info("Response.StatusDescription=" + ((HttpWebResponse)response).StatusDescription);
            // Get the stream containing content returned by the server.
            string strResponse = string.Empty;
            Stream dataStream = response.GetResponseStream();
            // Open the stream using a StreamReader for easy access.
            StreamReader reader = new StreamReader(dataStream, Encoding.UTF8);
            // Read the content.
            strResponse = reader.ReadToEnd();
            // Display the content.
             // Clean up the streams.
            reader.Close();
            dataStream.Close();
            response.Close();

            if (strResponse.IndexOf("http://reg.163.com") > -1)//如果访问网站成功，则网页中包含置顶的关键字符串“http://reg.163.com”表示访问网页成功     
            {
                return true;
            }
            else
            {
                return false;
            }
        }

        public static bool CheckValidationResult(object sender, X509Certificate certificate, X509Chain chain, SslPolicyErrors errors)
        {   // 总是接受    
            return true;
        }
    }
}
