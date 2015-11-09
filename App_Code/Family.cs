using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
/// <summary>
/// Summary description for Family
/// </summary>
public class Family
{
    public struct FamilyMember
    {
        public WeixinUser userInfo;
        public string role;
        public string name;
    }
    

    public int id = 0;

    public DataRow _fields;

	public Family(int familyId)
	{
        id = familyId;
        DataTable dt = DBHelper.GetDataTable(" select * from families where [id] = " + id.ToString());
        if (dt.Rows.Count > 0)
            _fields = dt.Rows[0];
        
	}

    public FamilyMember[] parents
    {
        get
        {
            DataTable dt = DBHelper.GetDataTable(" select * from parents where family_id = " + id.ToString());
            FamilyMember[] parentsArray = new FamilyMember[dt.Rows.Count];
            for (int i = 0; i < parentsArray.Length; i++)
            {
                parentsArray[i] = new FamilyMember();
                parentsArray[i].role = "parent";
                parentsArray[i].userInfo = new WeixinUser(dt.Rows[i]["open_id"].ToString().Trim());
            }
            return parentsArray;
        }
    }

    public FamilyMember[] children
    {
        get
        { 
            DataTable dt = DBHelper.GetDataTable(" select * from children where family_id = " + id.ToString());
            FamilyMember[] parentsArray = new FamilyMember[dt.Rows.Count];
            for (int i = 0; i < parentsArray.Length; i++)
            {
                parentsArray[i] = new FamilyMember();
                parentsArray[i].role = "child";
                parentsArray[i].userInfo = new WeixinUser(dt.Rows[i]["open_id"].ToString().Trim());
            }
            return parentsArray;
        }
    }
    

}