using System;
using System.Collections.Generic;
using System.Linq;


namespace BlackTech.Framework.Utility
{
	public static class EnumerableExtensions
	{
		public static IEnumerable<TSource> DistinctBy<TSource, TKey>(this IEnumerable<TSource> source, Func<TSource, TKey> keySelector)
		{
			HashSet<TKey> hashSet = new HashSet<TKey>();
			foreach (TSource current in source)
			{
				if (hashSet.Add(keySelector(current)))
				{
					yield return current;
				}
			}
			yield break;
		}

		public static HashSet<string> ToIgnoreCaseHashSet(this IEnumerable<string> items)
		{
			return new HashSet<string>(items, StringComparer.OrdinalIgnoreCase);
		}

		public static HashSet<T> ToHashSet<T>(this IEnumerable<T> items, IEqualityComparer<T> comparer = null)
		{
			return new HashSet<T>(items, comparer);
		}
    }
}

   
