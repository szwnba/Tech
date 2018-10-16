using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BlackTech.Framework.Utility
{
    public class DateTimeHelper
    {
        /// <summary>
        /// 计算两个时间的间隔天数。
        /// </summary>
        /// <param name="dtUseStartDate"></param>
        /// <param name="dtUseEndDate"></param>
        /// <returns></returns>
        public static int intervalDays(DateTime dtUseStartDate, DateTime dtUseEndDate)
        {
            int intervalDays = 0;
            TimeSpan tsUseStartDate = new TimeSpan(dtUseStartDate.Ticks);
            TimeSpan tsUseEndDate = new TimeSpan(dtUseEndDate.Ticks);
            intervalDays = tsUseEndDate.Subtract(tsUseStartDate).Days;
            return intervalDays;
        }

        /// <summary>
        /// 计算两个时间的间隔毫秒数。
        /// </summary>
        /// <param name="dtUseStartDate"></param>
        /// <param name="dtUseEndDate"> DateTime.Parse("1970-01-01 00:00:00")</param>
        /// <returns></returns>
        public static long intervalMilliseconds(DateTime dtUseStartDate, DateTime dtUseEndDate)
        {
            long intervalMilliseconds = 0;
            TimeSpan tsUseStartDate = new TimeSpan(dtUseStartDate.Ticks);
            TimeSpan tsUseEndDate = new TimeSpan(dtUseEndDate.Ticks);
            intervalMilliseconds = (long)tsUseEndDate.Subtract(tsUseStartDate).TotalMilliseconds;
            return intervalMilliseconds;
        }
    }
}
