using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.IO;
using Noemax.GZip;
using System.Reflection;

namespace Tech.Framework.Communication
{
    public class MessageEncodeDecode
    {
        public enum MessageContentEncoding
        {
            None,
            gzip,
            deflate
        };


        static public MemoryStream Encode(MemoryStream ms, String msgContentEncoding)
        {
            if (ms == null)
            {
                throw new ArgumentNullException("ms is null.");
            }

            if (msgContentEncoding == null)
            {
                throw new ArgumentNullException("msgContentEncoding is null.");
            }

            if (msgContentEncoding == MessageContentEncoding.gzip.ToString())
            {
                return CompressionGZip.Encode(ms);
            }
            else if (msgContentEncoding == MessageContentEncoding.None.ToString())
            {
                return ms;
            }

            throw new ArgumentOutOfRangeException("msgContentEncoding is out of range.");
        }

        static public MemoryStream Decode(MemoryStream ms, String msgContentDecoding)
        {
            if (ms == null)
            {
                throw new ArgumentNullException("ms is null.");
            }

            if (msgContentDecoding == null)
            {
                throw new ArgumentNullException("msgContentEncoding is null.");
            }

            if (msgContentDecoding == MessageContentEncoding.gzip.ToString())
            {
                return CompressionGZip.Decode(ms);
            }
            else if (msgContentDecoding == MessageContentEncoding.deflate.ToString())
            {
                return CompressionDeflate.Decode(ms);
            }
            else if (msgContentDecoding == MessageContentEncoding.None.ToString() || msgContentDecoding == "")
            {
                return ms;
            }

            throw new ArgumentOutOfRangeException("msgContentEncoding is out of range.");
        }
    }


    public class CompressionDeflate
    {
        static public MemoryStream Decode(MemoryStream msCompressed)
        {
            if (msCompressed == null)
            {
                throw new ArgumentNullException("msCompressed is null.");
            }

            msCompressed.Seek(0, SeekOrigin.Begin);

            MemoryStream msUncompressed = new MemoryStream();
            using (DeflateStream strm = new DeflateStream(msCompressed, CompressionMode.Decompress))
            {
                strm.CopyTo(msUncompressed);
            }

            msUncompressed.Seek(0, SeekOrigin.Begin);
            return msUncompressed;
        }
    }

    public class CompressionGZip
    {
        static public MemoryStream Encode(MemoryStream msUncompressed)
        {
            if (msUncompressed == null)
            {
                throw new ArgumentNullException("msUncompressed is null.");
            }

            msUncompressed.Seek(0, SeekOrigin.Begin);
            MemoryStream msCompressed = new MemoryStream();

            using (GZipStream strm = new GZipStream(msCompressed, CompressionMode.Compress))
            {
                msUncompressed.CopyTo(strm);
            }

            return msCompressed;
        }

        static public MemoryStream Decode(MemoryStream msCompressed)
        {
            if (msCompressed == null)
            {
                throw new ArgumentNullException("msCompressed is null.");
            }

            msCompressed.Seek(0, SeekOrigin.Begin);

            MemoryStream msUncompressed = new MemoryStream();
            using (GZipStream strm = new GZipStream(msCompressed, CompressionMode.Decompress))
            {
                strm.CopyTo(msUncompressed);
            }

            msUncompressed.Seek(0, SeekOrigin.Begin);
            return msUncompressed;
        }
    }
}
