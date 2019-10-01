using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Newtonsoft.Json;
using Newtonsoft.Json.Converters;
using System.IO;

namespace BlackTech.Framework.Utility
{
      public class JsonUtility
      {
            /// <summary> 
            /// json序列化方法
            /// </summary> 
            /// <typeparam name="T"></typeparam> 
            /// <param name="t"></param> 
            /// <returns></returns> 
            public static string ToJson<T>(T t)
            {
                  if (t == null) return string.Empty;
                  return Newtonsoft.Json.JsonConvert.SerializeObject(t);
            }

            public static string ToJson<T>(T t, string timeFormat)
            {
                  var converter = new IsoDateTimeConverter() { DateTimeFormat = timeFormat };

                  return JsonConvert.SerializeObject(t, converter);
            }

            /// <summary> 
            /// json反序列化方法
            /// </summary> 
            /// <typeparam name="T"></typeparam> 
            /// <param name="jsonString"></param> 
            /// <returns></returns> 
            public static T FromJson<T>(string jsonString)
            {
                  return JsonConvert.DeserializeObject<T>(jsonString, new JsonSerializerSettings { ReferenceLoopHandling = ReferenceLoopHandling.Ignore });
            }

            public static string FormatJsonString(string str)
            {
                //格式化json字符串
                JsonSerializer serializer = new JsonSerializer();
                TextReader tr = new StringReader(str);
                JsonTextReader jtr = new JsonTextReader(tr);
                object obj = serializer.Deserialize(jtr);
                if (obj != null)
                {
                    StringWriter textWriter = new StringWriter();
                    JsonTextWriter jsonWriter = new JsonTextWriter(textWriter)
                    {
                        Formatting = Formatting.Indented,
                        Indentation = 4,
                        IndentChar = ' '
                    };
                    serializer.Serialize(jsonWriter, obj);
                    return textWriter.ToString();
                }
                else
                {
                    return str;
                }
            }
      }
}