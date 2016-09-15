using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using System.IO;

/// <summary>
/// Summary description for PointFile
/// </summary>
public class PointFile
{

    public DataRow _fields;
    


	public PointFile()
	{
		//
		// TODO: Add constructor logic here
		//
	}

    public static int AddNewFile(string fileName, string memo)
    {
        int ret = 0;
        string fileFullName = System.Configuration.ConfigurationSettings.AppSettings["web_site_physical_path"].Trim() + @"\" 
            + fileName.Replace("/",@"\");
        if (File.Exists(fileFullName))
        {
            string fileMd5 = ComputeFileMd5(fileFullName);
            DataTable dt = DBHelper.GetDataTable(" select * from point_uploaded_file where md5 = '" + fileMd5 + "' ");
            if (dt.Rows.Count == 0)
            {
                string[,] insertParameters = new string[,] { {"path_name", "varchar", fileName.Trim()},
                    {"md5", "varchar", fileMd5}, {"memo", "varchar", memo.Trim()}};
                int i = DBHelper.InsertData("point_uploaded_file", insertParameters);
                if (i == 1)
                {
                    i = DBHelper.GetMaxValue("point_uploaded_file", "id", Util.conStr.Trim());
                }
            }
            dt.Dispose();
        }
        return ret;
    }

    public static string ComputeFileMd5(string fullFilePath)
    {
        string[] fileContentLineArr = File.ReadAllText(fullFilePath).Trim().Split('\n');
        string[] arrayToSort = new string[fileContentLineArr.Length];
        for (int i = 0; i < fileContentLineArr.Length; i++)
        {
            string[] lineArr = fileContentLineArr[i].Trim().Split(',');
            string lineString = "";
            foreach (string cellString in lineArr)
            {
                lineString = lineString + cellString.Trim();
            }
            arrayToSort[i] = lineString;
        }
        Array.Sort(arrayToSort);
        return Util.GetMd5(string.Join("",arrayToSort));
        
    }

}