通信相关
1.C#HttpHelper,Httpwebrequest,请求时无视编码，无视证书，无视Cookie,网页抓取   主要是实现了HTTP协议的GET|POST请求时的无视编码，无视证书，设置代理，自动获取Cookie的功能。

访问数据库相关
1.SqlHelper类  
      使用C#实现对Sql数据库的操作，执行存储过程，Sql语句，返回影响行数，返回DateTable,DataSet,DataReader,以及表集等方法。实现多个数据库的切换功能。功能强大，希望大家喜欢

2.一个操作Sql2005数据库的类（备份，还原，分离，附加，添加删除用户等操作）  
      这主要是为了让大家练手的，他使用C#代   码的方法实现了对数据的 备份，还原，分离，附加，添加和删除用户等操作
3.DbHelperMySQL类
      数据访问抽象基础类 主要是访问Mysql数据库主要实现如下功能
	1.得到最大值
	2.是否存在
	3.是否存在（基于MySqlParameter）
	4.执行SQL语句，返回影响的记录数
	5.执行MySql和Oracle滴混合事务，执行多条SQL语句，实现数据库事务。
	6.执行带一个存储过程参数的的SQL语句。
	7.执行带一个存储过程参数的的SQL语句。
	8.向数据库里插入图像格式的字段(和上面情况类似的另一种实例)
	9.执行一条计算查询结果语句，返回查询结果（object）。
	10.执行查询语句，返回MySqlDataReader ( 注意：调用该方法后，一定要对MySqlDataReader进行Close )
	11.执行查询语句，返回DataSet，执行SQL语句，返回影响的记录数，执行多条SQL语句，实现数据库事务。
	执行多条SQL语句，实现数据库事务。
	12.执行多条SQL语句，实现数据库事务。
	13.执行多条SQL语句，实现数据库事务。
	14.执行一条计算查询结果语句，返回查询结果（object）。
	15.执行查询语句，返回MySqlDataReader ( 注意：调用该方法后，一定要对MySqlDataReader进行Close )
	16.执行查询语句，返回DataSet等等。

4.DbHelperOleDb类
	1.数据访问基础类(基于OleDb)Access数据库，
	2.得到最大值；是否存在；是否存在（基于OleDbParameter）；
	3.执行SQL语句，返回影响的记录数；执行多条SQL语句，实现数据库事务；
	4.执行带一个存储过程参数的的SQL语句；
	5.向数据库里插入图像格式的字段(和上面情况类似的另一种实例);
	6.执行一条计算查询结果语句，返回查询结果（object）;
	7.执行查询语句，返回OleDbDataReader;
	8.执行查询语句，返回DataSet;
	9.执行SQL语句，返回影响的记录数;
	10.执行多条SQL语句，实现数据库事务;
	11.执行一条计算查询结果语句，返回查询结果（object）;
	12.执行查询语句，返回OleDbDataReader;执行查询语句，返回DataSet;

5.DbHelperOra类
	1.数据访问基础类(基于Oracle)，主要是用来访问Oracle数据库的。
	2.得到最大值；是否存在；是否存在（基于OracleParameter ）；
	3.执行SQL语句，返回影响的记录数;
	4.执行多条SQL语句，实现数据库事务;
	5.执行带一个存储过程参数的的SQL语句;
	6.向数据库里插入图像格式的字段(和上面情况类似的另一种实例);
	7.执行一条计算查询结果语句，返回查询结果（object）;
	8.执行查询语句，返回OracleDataReader ( 注意：调用该方法后，一定要对SqlDataReader进行Close );
	9.执行查询语句，返回DataSet;
	10.执行SQL语句，返回影响的记录数;
	11.执行多条SQL语句，实现数据库事务;
	12.执行一条计算查询结果语句，返回查询结果（object）;
	13.执行查询语句，返回OracleDataReader ( 注意：调用该方法后，一定要对SqlDataReader进行Close );
	14.执行查询语句，返回DataSet;
	15.执行存储过程 返回SqlDataReader ( 注意：调用该方法后，一定要对SqlDataReader进行Close );
	16.执行存储过程;构建 OracleCommand 对象(用来返回一个结果集，而不是一个整数值);
	17.执行存储过程，返回影响的行数;
	18.创建 OracleCommand 对象实例(用来返回一个整数值)

6.DbHelperSQLite类
    1.数据访问基础类(基于SQLite)，主要是用来访问SQLite数据库的。
    2.得到最大值；是否存在；是否存在（基于SQLiteParameter）；
    3. 执行SQL语句，返回影响的记录数
    4.执行多条SQL语句，实现数据库事务。
    5.执行带一个存储过程参数的的SQL语句。
    6.向数据库里插入图像格式的字段(和上面情况类似的另一种实例)
    7.执行一条计算查询结果语句，返回查询结果（object）。
    8.执行查询语句，返回SQLiteDataReader
    9.执行查询语句，返回DataSet
    10.执行SQL语句，返回影响的记录数
    11. 执行多条SQL语句，实现数据库事务。
    12. 执行一条计算查询结果语句，返回查询结果（object）。
    13.执行查询语句，返回SQLiteDataReader
    14.执行查询语句还参数，返回DataSet[/code]
7.DbHelperSQLP类
8.DbHelperSQL类  
9.OracleHelper类
      
帮助类
1.最新的Functions 类 
      这里面实现了很多的帮助方法，比如正则验证，加密，解密，MD5加密，字符串的处理等操作。
2.最新的 PageValidate 类
      主要是实现了验证，是否为空，是否为数字等。
3.JavascriptHelp
      帮助输出简单的JS代码
4.最新的皮肤帮助类 UI_Misc_Helper

JavaScript|Jquery相关
1.jQuery.cookie帮助类

访问系统相关
1.C#计算机信息类ComputerInfo
      实现了计算机的信息获取功能，计算机名，IP，硬盘信息，网卡信息，操作系统信息等
2.Api_Win32_Mac类工具包
     一个Win32的Api包，实现了大部分的Api操作帮助方法
3.在c#程序中放音乐的帮助类
      使用C#播放音乐的帮助类，只需要调用方法就可以放音乐了

GDI+相关，图像相关
1.生成缩略图的类文件SmallImage
      一个把图片生成缩略图的类，可以设置大小，非常好用，希望大家喜欢哦。

C#基础类库
1.Chart图形
	Assistant创建显示图像的标签和文件
	OWCChart统计图的封装类
2.Cookie&Session&Cache缓存帮助类 
	CacheHelper  
		  C#操作缓存的帮助类，实现了怎么设置缓存，怎么取缓存，怎么清理缓存等方法，只需要调用方法就可以实现
	CookieHelper  
		  C#操作Cookie的帮助类，添加Cookie，删除Cookie，修改Cookie，清理Cookie
	SessionHelper  
		  C#关于Session的操作，获取Session，设置Session，删除Session使用方便，只需要调用方法就可以了
	SessionHelper2 
		  C#关于Session的一些高级操作，比如取Session对象，取Session数据等等
3.CSV文件转换
	CsvHelper    
		  CSV文件导入DataTable和DataTable导出到Csv文件等操作
4.DEncrypt  加密/解密帮助类
	DEncrypt      
		  C#DEncrypt加密/DEncrypt解密帮助类 ，多种方式，可以设置Key
	DESEncrypt  
		  C#DESEncrypt加密/DESEncrypt解密帮助类 ，多种方式，可以设置Key
	Encrypt        
		  C#Encrypt--Encrypt加密/Encrypt解密/附加有MD5加密，个人感觉很不错的一个加密类
	HashEncode  
		  哈希加密帮助类，得到随机哈希加密字符串，随机哈希数字加密等
	MySecurity    
		  MySecurity--Security安全加密/Security Base64/Security文件加密，以及一些常用的操作方法
	RSACryption  
		  RSACryption--RSA加密/RSA解密字符串 RSA加密应用最多是银行接口，这里的方法可以直接使用哦
5.FTP操作类
	FTPClient　　
		  FTPClient--FTP操作帮助类，FTP上传，FTP下载，FTP文件操作，FTP目录操作
	FTPHelper      
		  FTPHelper－FTP帮助类,FTP常用操作方法，添加文件，删除文件等
	FTPOperater  
		  FTP操作帮助类，方法比较多，比较实用
6.JS操作类
	JsHelper    
      JsHelper--Javascript操作帮助类，输出各种JS方法，方便不懂JS的人使用，减少代码量
7.JSON 转化类
	ConvertJson 
      List转成Json|对象转成Json|集合转成Json|DataSet转成Json|DataTable转成Json|DataReader转成Json等
8.Mime
	MediaTypes  
		  电子邮件类型帮助类，规定是以Xml，HTML还是文本方式发送邮件
	MimeEntity   
		  Mime实体帮助类
	MimeHeaders  
		  mime的Header帮助类
	MimeReader    
		  mime读取帮助类
	QuotedPrintableEncoding  
		  mimeEncoding帮助类
9.PDF  转化类
	PDFOperation  
		  PDFOperation--C#PDF文件操作帮助类 类主要功能有1.构造函数2.私有字段3.设置字体4.设置页面大小
	5.实例化文档6.打开文档对象7.关闭打开的文档8.添加段落9.添加图片10.添加链接、点 等功能
10.ResourceManager 操作类
	AppMessage  
		  app消息格式化类，返加字符串帮助类
	ResourceManager
		  C#一个操作Resource的帮助类
	ResourceManagerWrapper
	Resources   
		  操作Resources的帮助类，使用Api的方式
	Sample.xml
11.XML操作类
	XmlHelper  
		  操作Xml文档的帮助类，主要是添加，删除，修改，查询节点的操作和操作后进行保存的功能。
	XMLProcess
		  操作Xml文档的帮助类，主要是添加，删除，修改，查询节点的操作的功能。
12.弹出消息类
	MessageBox
		  JS弹出信息帮助类
	ShowMessageBox
		  相对于MessageBox更丰富的提示类
13.导出Excel 操作类
	DataToExcel   
		  从“Excel导出数据的帮助类
	ExcelHelper   
		  导出到文件，导出一部分集合，从DataTable中操作等
	ExportExcel  
		  主要功能如下1.将整个网页导出来Excel 2.将GridView数据导出Excel
	GridViewExport
		  主要功能:将整GridView的数据导出到Excel中关增加一个效果线做美化
14.分词辅助类
	SegList 
		  C#SegList分词辅助类,帮助类
15.汉字转拼音
	EcanConvertToCh C#将汉字转成拼音
	PinYin
	取汉字拼音的首字母，只要你输入一个汉字，或者是多个汉字就会取出相应的道字母，主要是方便查询使用的
 
16.配置文件操作类
	ConfigHelper
		1.根据Key取Value值
		2.根据Key修改Value
		3.添加新的Key ，Value键值对
		4.根据Key删除项

17.日历
	CNDate
		1.传回公历y年m月的总天数
		2.根据日期值获得周一的日期
		3.获取农历
 
18.上传下载
	DownLoadHelper
	输出硬盘文件，提供下载 支持大文件、续传、速度限制、资源占用小
 
	FileDown
		1.参数为虚拟路径
		2.获取物理地址
		3.普通下载
		4.分块下载
		5.输出硬盘文件，提供下载 支持大文件、续传、速度限制、资源占用小
 
	FileUp
	1.把上传的文件转换为字节数组
	2.流转化为字节数组
	2.上传文件根据FileUpload控件上传
	3.把Byte流上传到指定目录并保存为文件
 
	UpLoadFiles
		  页面专用类
19.时间操作类
	DateFormat
	返回每月的第一天和最后一天
 
	TimeHelper
		1.将时间格式化成 年月日 的形式,如果时间为null，返回当前系统时间
		2.将时间格式化成 时分秒 的形式,如果时间为null，返回当前系统时间
		3.把秒转换成分钟
		4.返回某年某月最后一天
		5.返回时间差
		6.获得两个日期的间隔
		7.格式化日期时间
		8.得到随机日期
 
20.视频转换类
	VideoConvert
	1.获取文件的名字
	2.获取文件扩展名
	3.获取文件类型
	4.视频格式转为Flv
	5.生成Flv视频的缩略图
	6.转换文件并保存在指定文件夹下
	7.转换文件并保存在指定文件夹下
	8.运行mencoder的视频解码器转换
 
21.随机数类
	BaseRandom
	1.产生随机字符
	2.产生随机数
	3.在一定范围内产生随机数
 
	RandomHelper
	1.生成一个指定范围的随机整数，该随机数范围包括最小值，但不包括最大值
	2.生成一个0.0到1.0的随机小数
	3.对一个数组进行随机排序
	4. 一：随机生成不重复数字字符串  
	5.方法二：随机生成字符串（数字和字母混和）
	6.从字符串里随机得到，规定个数的字符串.
 
22.条形码
	BarCodeToHTML 
		  本类是个条码生成类，大家可根据需要自己设置，非常好用
23.图片
	ImageClass 
		  主要功能有：缩略图片，图片水印，文字水印，调整光暗，反色处理，浮雕处理，拉伸处理，左右翻转，上下翻转，
	压缩图片，图片灰度化，转换为黑白图片，获取图片中的各帧
	ImageDown
		  主要功能，把图片下载到本地
	ImageUpload  图片上传并进行缩略图处理
24.网络
	NetHelper
25.文件操作类
	DirFileHelper
	FileOperateHelper
	INIFile
26.序列化
	Serialize   
		  序列化帮助类，还有例子
	SerializeHelper 
		  序列化帮助类，Xml序列化，Json序列化,SoapFormatter序列化,BinaryFormatter序列化
27.压缩解压缩
	SharpZip
28.验证码
	YZMHelper
	Captcha 
		  验证码类，一个很个性的验证码类
29.页面辅助类
	HTMLHelper
	UploadEventArgs
	JavaScriptPlus
	PageHelper
30.邮件
	MailHelper
	MailPoper
	MailSender
	SmtpServerHelper
31.邮件2
	ConnectCommand
	ConnectResponse
	DeleCommand
	ListCommand
	ListResponse
	MailHeaders
	MailMessageEx
	NoopCommand
	PassCommand
	Pop3Client
	Pop3Command
	Pop3Commands
	Pop3Exception
	Pop3ListItem
	Pop3Response
	Pop3Responses
	Pop3State
	QuitCommand
	RetrCommand
	RetrResponse
	RsetCommand
	Stat
	StatCommand
	StatResponse
	TopCommand
	UserCommand
32.正则表达式
	RegexHelper
33.字符串
	StringHelper
34.其它
	BasePage
	BindDataControl
	ConvertHelper
	DataCache
	FormulaExpress
	GridViewHelper
	IpHelper
	MediaHandler
	PageValidate
	PicDeal
	QueryString
	Rmb
	StringPlus
	SysHelper
	Tools
	UrlOper
	Utility
	ValidateImg
	WebSitePathHelper

35.2016-6-28新增
InputHelper
IPHelper
JsonHelper
SerializerJsonHelper
SeoHelper
WebHelper
FilterHelper