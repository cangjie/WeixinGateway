using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using System.Data.SqlClient;

/// <summary>
/// Summary description for OilDetail
/// </summary>
public class OilDetail
{

    public DataRow _fields;

	public OilDetail()
	{
		//
		// TODO: Add constructor logic here
		//
	}

    public OilDetail(int id)
    {
        SqlDataAdapter da = new SqlDataAdapter(" select * from oildetail where oildetail_id = " + id.ToString(), Util.conStr.Trim());
        DataTable dt = new DataTable();
        da.Fill(dt);
        da.Dispose();
        _fields = dt.Rows[0];
    }

    public OilDetail(string name)
    {
        SqlDataAdapter da = new SqlDataAdapter(" select * from oildetail where oildetail_name like '%" + name.Replace("'","").Trim() + "%' or oildetail_keyword like '%" +  name.Replace("'","").Trim() + "%' ", Util.conStr.Trim());
        DataTable dt = new DataTable();
        da.Fill(dt);
        da.Dispose();
        _fields = dt.Rows[0];
    }

    public int ID
    {
        get
        {
            return int.Parse(_fields["oildetail_id"].ToString().Trim());
        }
    }

    public string Name
    {
        get
        {
            return _fields["oildetail_name"].ToString().Trim();
        }
    }

    public string Alias
    {
        get
        {
            return _fields["oildetail_keyword"].ToString().Trim();
        }
    }

    public string PlantImage
    {
        get
        {
            return _fields["oildetail_plantimg"].ToString().Trim();
        }
    }

    public string Smell
    {
        get
        {
            return _fields["oildetail_smell"].ToString();
        }
    }

    public string Use
    {
        get
        {
            return _fields["oildetail_use"].ToString().Trim();
        }
    }

    public string BodyEffectArea
    {
        get
        {
            return _fields["oildetail_body"].ToString().Trim();
        }
    }

    public string Topical
    {
        get
        {
            return _fields["oildetail_topical"].ToString().Trim();
        }
    }

    public string Aroma
    {
        get
        {
            return _fields["oildetail_aroma"].ToString().Trim();
        }
    }

    public string InnerUse
    {
        get
        {
            return _fields["oildetail_inner"].ToString().Trim();
        }
    }

    public string Memo
    {
        get
        {
            return _fields["oildetail_memo"].ToString().Trim();
        }
    }
}