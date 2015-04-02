using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

public class FormItem
{
    public string Name { get; set; }
    public ParamType ParamType { get; set; }
    public string Value { get; set; }
}

public enum ParamType
{
    ///
    /// 文本类型
    ///
    Text,
    ///
    /// 文件路径，需要全路径（例：C:\A.JPG)
    ///
    File
}