using BlackTech.Framework.Communication;
using BlackTech.Framework.Utility;
using Ctrip.Automation.Framework.Lib;
using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net;
using System.Reflection;
using System.Text;
using System.Threading.Tasks;
using System.Xml;

namespace Corp.Tool.Web.Common
{
    public class SOAHelper
    {
        public static string runEnvName = "FAT";
        public static string token = "123";
        public static string refreshtoken = "123";


        /// <summary>
        /// 发送request，请求头中ContentType=application/XML; charset=UTF-8 
        /// 返回的response为XML格式
        /// </summary>
        /// <param name="url"></param>
        /// <param name="request"></param>
        /// <returns>string</returns>
        public static string SendGet(string url)
        {
            string response = null;
            try
            {
                response = CommunicationManager.sendGet(url);
            }
            catch (Exception e)
            {
                throw e;
            }
            return response;
        }

        /// <summary>
        /// 发送request，请求头中ContentType=application/XML; charset=UTF-8 
        /// 返回的response为XML格式
        /// </summary>
        /// <param name="url"></param>
        /// <param name="request"></param>
        /// <returns>string</returns>
        public static string SendRequest(string url, string request)
        {
            string response = null;
            try
            {
                CommunicationInformation commInfo = new CommunicationInformation(url, MsgProtocol.Text, MessageFormat.MessageContentType.Xml);
                response = CommunicationManager.send(request, commInfo);
            }
            catch (Exception e)
            {
                throw e;
            }
            return response;
        }

        /// <summary>
        /// 发送request，请求头中ContentType=application/Json; charset=UTF-8 
        /// 返回的response为Json格式
        /// </summary>
        /// <param name="url"></param>
        /// <param name="request"></param>
        /// <returns>string</returns>
        public static string SendInteropJsonRequest(string url, string request)
        {
            string response = null;
            try
            {
                CommunicationInformation commInfo = new CommunicationInformation(url, MsgProtocol.Interop, MessageFormat.MessageContentType.Json);
                response = CommunicationManager.send(request, commInfo);
            }
            catch (Exception e)
            {
                throw e;
            }
            return response;
        }

        /// <summary>
        /// 发送request，请求头中ContentType=application/Json; charset=UTF-8 
        /// 返回的response为Json格式
        /// </summary>
        /// <param name="url"></param>
        /// <param name="request"></param>
        /// <returns>string</returns>
        public static string SendJsonRequest(string url, string request)
        {
            string response = null;
            try
            {
                CommunicationInformation commInfo = new CommunicationInformation(url, MsgProtocol.Text, MessageFormat.MessageContentType.Json);
                response = CommunicationManager.send(request, commInfo);
            }
            catch (Exception e)
            {
                throw e;
            }
            return response;
        }


        public static TRes SendXmlRequest<TReq, TRes>(TReq request, string url, Encoding encode = null, string requestName = "")
        {
            Log.Info(string.Format("Start send request to server. URL={0}", url));
            string requestStr = TypeTransferHelper.ObjToStr(request);
            CommunicationInformation commInfo = new CommunicationInformation(url, MsgProtocol.Text, MessageFormat.MessageContentType.Xml);
            string responseStr = (runEnvName == "PROD") ? CommunicationManager.send(requestStr, commInfo, requestName: requestName) : CommunicationManager.send(requestStr, commInfo, requestName: requestName);
            TRes response = (TRes)TypeTransferHelper.strToObj(responseStr, typeof(TRes));

            return response;
        }

        public static TRes SendJsonRequest<TReq, TRes>(TReq request, string url, Encoding encode = null, string requestName = "")
            where TReq : class
            where TRes : class
        {
            Log.Info(string.Format("Start send request to server. URL={0}", url));
            string requestJson = TypeTransferHelper.ToJson<TReq>(request);

            CommunicationInformation commInfo = new CommunicationInformation(url, MsgProtocol.Text, MessageFormat.MessageContentType.Json);
            string responseJson = (runEnvName == "PROD") ? CommunicationManager.send(requestJson, commInfo, requestName: requestName) : CommunicationManager.send(requestJson, commInfo, requestName: requestName);
            TRes response = TypeTransferHelper.ToObject<TRes>(responseJson);

            return response;
        }
    
    }
}
