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
    


	public PointFile(int id)
	{
		//
		// TODO: Add constructor logic here
		//
        DataTable dt = DBHelper.GetDataTable(" select * from point_uploaded_file  where [id] = " + id.ToString());
        if (dt.Rows.Count == 1)
        {
            _fields = dt.Rows[0];
        }
        else
        {
            throw new Exception("Record not found.");
        }

	}

    public int ImportUploadedPointFileToDB()
    {
        int i = 0;
        if (isFileValid && !hasImported)
        {
            DataTable dt = pointDataTable;
            foreach (DataRow dr in dt.Rows)
            {
                string[,] insetParameters = new string[,] { {"file_id", "int", ID.ToString() }, {"cell_number", "varchar", dr[0].ToString().Trim() }, 
                {"points", "int", dr[2].ToString().Trim() }, {"points_date", "datetime", dr[1].ToString().Trim()}, {"memo", "varchar", dr[3].ToString().Trim()} };
                i = i + DBHelper.InsertData("point_uploaded_detail", insetParameters);
            }
            
        }
        if (i > 0)
        {
            string[,] updateParameters = new string[,] { { "deal", "int", "1" } };
            string[,] keyParameters = new string[,] { {"id", "int", ID.ToString() } };
            DBHelper.UpdateData("point_uploaded_file", updateParameters, keyParameters, Util.conStr);
        }
        return i;
    }

    public bool hasImported
    {
        get
        {
            bool imported = true;
            DataTable dt = DBHelper.GetDataTable(" select * from point_uploaded_detail where file_id = " + ID.ToString());
            if (dt.Rows.Count == 0 && _fields["deal"].ToString().Equals("0"))
            {
                imported = false;
            }
            dt.Dispose();
            return imported;
        }
    }

    public int ID
    {
        get
        {
            return int.Parse(_fields["id"].ToString());
        }
    }

    public string fullFilePathAndName
    {
        get
        {
            return System.Configuration.ConfigurationSettings.AppSettings["web_site_physical_path"].Trim()
                + @"\pages\" + _fields["path_name"].ToString().Trim().Replace("/", @"\");
        }
    }

    public bool isFileValid
    {
        get
        {
            int[] validResult = ValidateUploadedPointTable(pointDataTable);
            if (validResult[0] == -1 && validResult[1] == -1)
                return true;
            else
                return false;
        }
    }

    public DataTable pointDataTable
    {
        get
        {
            DataTable dt = ConvertUploadedPointFileToDataTable(fullFilePathAndName);
            return dt;
        }
    }

    public int totalPoints
    {
        get
        {
            int points = 0;
            foreach (DataRow dr in pointDataTable.Rows)
            {
                points = points + int.Parse(dr["points"].ToString().Trim());
            }
            return points;
        }
    }

    public static int AddNewFile(string fileName, string memo)
    {
        int ret = 0;
        string fileFullName = System.Configuration.ConfigurationSettings.AppSettings["web_site_physical_path"].Trim() + @"\pages\" 
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
                    ret = DBHelper.GetMaxValue("point_uploaded_file", "id", Util.conStr.Trim());
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

    public static int[] ValidateUploadedPointTable(DataTable pointTable)
    {
        int[] retArray = new int[] { -1, -1 };

        for (int i = 0; i < pointTable.Rows.Count; i++)
        {
            if (!Util.IsCellNumber(pointTable.Rows[i][0].ToString()))
            {
                retArray[0] = i;
                retArray[1] = 0;
                break;
            }
            try
            {
                DateTime.Parse(pointTable.Rows[i][1].ToString().Trim());
            }
            catch
            {
                retArray[0] = i;
                retArray[1] = 1;
                break;
            }
            if (!Util.IsNumeric(pointTable.Rows[i][2].ToString().Trim()))
            {
                retArray[0] = i;
                retArray[1] = 2;
                break;
            }
        }
        return retArray;
    }

    public static DataTable ConvertUploadedPointFileToDataTable(string fullFilePath)
    {
        DataTable dt = new DataTable();
        dt.Columns.Add("number");
        dt.Columns.Add("date");
        dt.Columns.Add("points");
        dt.Columns.Add("memo");
        string[] lineStringArray = File.ReadAllText(fullFilePath).Trim().Split('\n');
        foreach (string lineString in lineStringArray)
        {
            DataRow dr = dt.NewRow();
            string[] cellStringArray = lineString.Split(',');
            for (int i = 0; i < cellStringArray.Length; i++)
            {
                dr[i] = cellStringArray[i].Trim();
            }
            dt.Rows.Add(dr);
        }
        return dt;
    }

    

}