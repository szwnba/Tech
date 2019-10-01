using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Corp.API.COIES.Utility
{
    /// <summary>
    /// 工具类
    /// </summary>
    public static class StringUtility
    {
        /// <summary>
        /// 数据库单元格转换为ushort类型
        /// </summary>
        /// <param name="obj">数据库单元</param>
        /// <param name="defaultvalue">默认值</param>
        /// <returns>ushort类型</returns>
        public static ushort DBCellToUShort(this object obj, ushort defaultvalue)
        {
            if (obj == null)
            {
                return defaultvalue;
            }

            ushort linshort = 0;
            if (ushort.TryParse(obj.DBCellToString(), out linshort))
            {
                return linshort;
            }
            else
            {
                return defaultvalue;
            }
        }

        /// <summary>
        /// 数据库单元格转换为short类型
        /// </summary>
        /// <param name="obj">数据库单元</param>
        /// <param name="defaultvalue">默认值</param>
        /// <returns>short类型</returns>
        public static short DBCellToShort(this object obj, short defaultvalue)
        {
            if (obj == null)
            {
                return defaultvalue;
            }

            short linshort = -1;
            if (short.TryParse(obj.DBCellToString(), out linshort))
            {
                return linshort;
            }
            else
            {
                return defaultvalue;
            }
        }

        public static int DBCellToInt32(this object obj, int defaultvalue)
        {
            if(obj==null)
            {
                return defaultvalue;
            }

            int linint = -1;
            if(int.TryParse(obj.DBCellToString(),out linint))
            {
                return linint;
            }
            else
            {
                return defaultvalue;
            }
        }

        /// <summary>
        /// 将数据单元格字符串内容转换为byte数组
        /// </summary>
        /// <param name="obj">字符串</param>
        /// <returns>byte数组</returns>
        public static byte[] DBCellStringToByte(this object obj)
        {
            if (obj == null)
            {
                // 假如对象为null，则返回空
                return null;
            }

            string strTemp = obj.ToString().Trim();
            if (strTemp.Length == 0)
            {
                // 假如字符串的长度为0，则返回空
                return null;
            }

            return Encoding.UTF8.GetBytes(strTemp);
        }

        /// <summary>
        /// byte数组转换为字符串
        /// </summary>
        /// <param name="obj"> byte数组</param>
        /// <returns>字符串</returns>
        public static string BytesToString(this byte[] obj)
        {
            if (obj == null || obj.Length == 0)
                return string.Empty;
            return Encoding.UTF8.GetString(obj);
        }

        /// <summary>
        /// 将数据库单元格的值变化为值
        /// </summary>
        /// <param name="obj">数据库单元格</param>
        /// <returns>值</returns>
        public static string DBCellToString(this object obj)
        {
            if (obj == null)
            {
                // 假如对象为null，则返回空字符串
                return string.Empty;
            }

            string strTemp = obj.ToString().Trim();
            if (strTemp.Length == 0)
            {
                // 假如字符串的长度为0，则返回空字符串
                return string.Empty;
            }

            return string.Intern(strTemp);
        }

        /// <summary>
        /// 日期转换为字符串
        /// </summary>
        /// <param name="dateTime">日期</param>
        /// <returns>字符串</returns>
        public static string ToDBDateTime(this DateTime dateTime)
        {
            if (dateTime == null || dateTime == DateTime.MinValue || dateTime == DateTime.MaxValue)
                return DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss");
            return dateTime.ToString("yyyy-MM-dd HH:mm:ss");
        }

		/// <summary>
        /// 字符串转换为日期
        /// </summary>
        /// <param name="dateTime">日期</param>
        /// <returns>字符串</returns>
        public static DateTime strToDateTime(string dateTime)
        {
            if (dateTime == null || dateTime == string.Empty)
                return DateTime.MinValue;
            return DateTime.ParseExact(dateTime,"yyyy-MM-dd HH:mm:ss",null);
        }


        /// <summary>
        /// 将逗号分隔的字符串转成整形列表
        /// </summary>
        /// <param name="value">输入字符串</param>
        /// <returns>整形列表</returns>
        public static List<int> ToIntList(this string value)
        {
            List<int> list = new List<int>();

            if (!string.IsNullOrEmpty(value) && value.Trim() != string.Empty)
            {
                list = value.Split(',').ToList().ConvertAll<int>(Convert.ToInt32);
            }

            return list;
        }



        /// <summary>
        /// 转换成携程城市名
        /// </summary>
        /// <param name="cityName"></param>
        /// <returns></returns>
        public static string ConventToCtripCityName(string cityName)
        {
            if (!String.IsNullOrWhiteSpace(cityName))
            {
                if (cityName.Length > 2)
                {
                    if (cityName.EndsWith("市") || cityName.EndsWith("县"))
                    {
                        cityName = cityName.Substring(0, cityName.Length - 1);
                    }
                    cityName = cityName.Replace("特别行政区", "");
                    cityName = cityName.Replace("特別行政區", "");
                }
                if (cityName.Equals("澳門", StringComparison.InvariantCultureIgnoreCase))
                {
                    cityName = "澳门";
                }
            }

            return cityName;

        }

        /// <summary>
        /// 携程省份对照
        /// </summary>
        private static readonly Dictionary<string, string> provinceNameDic = new Dictionary<string, string>
        {
            {"河北省", "河北"},
            {"山西省", "山西"},
            {"辽宁省", "辽宁"},
            {"吉林省", "吉林"},
            {"黑龙江省", "黑龙江"},
            {"江苏省", "江苏"},
            {"浙江省", "浙江"},
            {"安徽省", "安徽"},
            {"福建省", "福建"},
            {"江西省", "江西"},
            {"山东省", "山东"},
            {"河南省", "河南"},
            {"湖北省", "湖北"},
            {"湖南省", "湖南"},
            {"广东省", "广东"},
            {"海南省", "海南"},
            {"四川省", "四川"},
            {"贵州省", "贵州"},
            {"云南省", "云南"},
            {"陕西省", "陕西"},
            {"甘肃省", "甘肃"},
            {"青海省", "青海"},
            {"台湾省", "台湾"},
            {"内蒙古自治区", "内蒙古"},
            {"广西壮族自治区", "广西"},
            {"西藏自治区", "西藏"},
            {"宁夏回族自治区", "宁夏"},
            {"新疆维吾尔自治区", "新疆"},
            {"香港特别行政区", "香港"},
            {"香港特別行政區", "香港"},
            {"澳门特别行政区", "澳门"},
            {"澳門特別行政區", "澳门"},
            {"上海市", "上海"},
            {"上海省", "上海"},
            {"重庆市", "重庆"},
            {"重庆省", "重庆"},
            {"北京市", "北京"},
            {"北京省", "北京"},
            {"天津市", "天津"},
            {"天津省", "天津"},
        };

        /// <summary>
        /// 转换成携程省份名
        /// </summary>
        /// <param name="provinceName"></param>
        /// <returns></returns>
        public static string ConventToCtripProvinceName(string provinceName)
        {

            if (!String.IsNullOrWhiteSpace(provinceName))
            {
                string result;
                if (provinceNameDic.TryGetValue(provinceName, out result))
                {
                    return result;
                }
            }
            return provinceName;
        }


        public static string GetStringByIndex(this string s, int index, char splitor = ',')
        {
            int len;
            if (s == null || (len = s.Length) < 1 || index < 0 || index >= len)
            {
                return "";
            }
            var startStrIndex = 0;
            var curItemindex = 0;
            for (var i = 0; i < len; i++)
            {
                var c = s[i];
                if (c == splitor)
                {
                    if (curItemindex == index)
                    {
                        if (i != startStrIndex)
                        {
                            return s.Substring(startStrIndex, i - startStrIndex);
                        }
                        else
                        {
                            return "";
                        }
                    }
                    startStrIndex = i + 1;
                    curItemindex++;
                }
            }
            if (curItemindex == index && len - 1 != startStrIndex)
            {
                return s.Substring(startStrIndex, len - startStrIndex);
            }
            return "";
        }

        public static bool StringCompare(string s1, string s2)
        {
              string s1Trimed = string.IsNullOrEmpty(s1) ? string.Empty : s1.Trim();
              string s2Trimed = string.IsNullOrEmpty(s2) ? string.Empty : s2.Trim();

              return s1Trimed.Equals(s2Trimed, System.StringComparison.OrdinalIgnoreCase);
        }
    }
}
