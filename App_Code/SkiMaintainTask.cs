using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;

/// <summary>
/// Summary description for SkiMaintainTask
/// </summary>
public class SkiMaintainTask
{

    public DataRow _fields;
    
    public SkiMaintainTask()
    {
        //
        // TODO: Add constructor logic here
        //
    }

    public SkiMaintainTask(int id)
    {
        DataTable dt = DBHelper.GetDataTable(" select * from skis_maintain_task where [id] = " + id.ToString());
        if (dt.Rows.Count > 0)
        {
            _fields = dt.Rows[0];
        }
    }

    public int Edge
    {
        get
        {
            return int.Parse(_fields["edge"].ToString());
        }
    }
    public DateTime CreateDate
    {
        get
        {
            return DateTime.Parse(_fields["create_date"].ToString());
        }
    }

    public DateTime ScheduledFinishDate
    {
        get
        {
            return DateTime.Parse(_fields["scheduled_finish_date_time"].ToString());
        }
    }

    public bool FixBoard
    {
        get
        {
            if (_fields["fix_board"].ToString().Trim().Equals("1"))
            {
                return true;
            }
            else
            {
                return false;
            }
        }
    }

    public bool NeedCandle
    {
        get
        {
            if (_fields["candle"].ToString().Trim().Equals("1"))
            {
                return true;
            }
            else
            {
                return false;
            }
        }
    }



    public int PlaceOrder(int amount, string memo)
    {
        int orderId = 0;
        int productId = 0;
        string productName = "";
        if (_fields["associate_order_id"].ToString().Equals("0") && _fields["associate_card_no"].ToString().Trim().Equals(""))
        {
            switch (_fields["shop"].ToString().Trim())
            {
                case "万龙":
                    if (!FixBoard)
                    {
                        if (Edge > 87)
                        {
                            if (NeedCandle)
                            {
                                if (CreateDate.Date == ScheduledFinishDate.Date)
                                {
                                    //修板打蜡立等
                                    productId = 137;
                                }
                                else
                                {
                                    //修板打蜡次日
                                    productId = 139;
                                }
                            }
                            else
                            {
                                if (CreateDate.Date == ScheduledFinishDate.Date)
                                {
                                    //修板立等
                                    productId = 138;
                                }
                                else
                                {
                                    //修板次日
                                    productId = 140;
                                }
                            }
                        }
                        else if (Edge == 0)
                        {
                            if (NeedCandle)
                            {
                                if (CreateDate.Date == ScheduledFinishDate.Date)
                                {
                                    //打蜡立等
                                    productId = 142;
                                }
                                else
                                {
                                    //打蜡次日
                                    productId = 143;
                                }
                            }
                        }
                        else
                        {
                            productName = "修刃" + Edge.ToString() + "度";
                        }
                    }
                    else
                    {
                        productName = "补板底";
                        if (Edge <= 87 && Edge > 0)
                        {
                            productName = productName + " 修刃" + Edge.ToString() + "度";
                        }
                    }
                    break;
                default:
                    break;
            }
            OnlineOrder newOrder = new OnlineOrder();
            OnlineOrderDetail detail = new OnlineOrderDetail();
            if (productId != 0)
            {

                Product p = new Product(productId);
                detail.productId = int.Parse(p._fields["id"].ToString());
                detail.productName = p._fields["name"].ToString();
                detail.price = double.Parse(p._fields["sale_price"].ToString()) + double.Parse(p._fields["deposit"].ToString());
                detail.count = 1;
                newOrder.Type = p._fields["type"].ToString();
                newOrder.shop = p._fields["shop"].ToString();

            }
            else
            {
                detail.productId = 0;
                detail.productName = productName.Trim();
                detail.price = amount;
                detail.count = 1;
                newOrder.Type = "服务";
                newOrder.shop = "万龙";

            }
            newOrder.AddADetail(detail);
            newOrder.Memo = memo.Trim();
            orderId = newOrder.Place(_fields["customer_open_id"].ToString().Trim());
        }
        if (orderId > 0)
        {
            DBHelper.UpdateData("skis_maintain_task",
                new string[,] { { "associate_order_id", "int", orderId.ToString() }, { "update_date", "datetime", DateTime.Now.ToString() } },
                new string[,] { {"id", "int", _fields["id"].ToString()} }, Util.conStr);

        }
        return orderId;
    }

    public static int CreateNewTask(string customerOpenId, string staffOpenId, int skiId, int edge, bool candle, bool fixBoard, 
        string memo, DateTime scheduledFinishTime, string cardNo, string extendService)
    {
        int taskId = 0;
        int i = DBHelper.InsertData("skis_maintain_task", new string[,] { {"ski_id", "int", skiId.ToString() }, {"edge", "int", edge.ToString() }, 
            {"candle", "int", (candle? "1" : "0")}, {"fix_board", "int", (fixBoard? "1":"0") }, {"memo", "varchar", memo.Trim() },
            {"customer_open_id", "varchar", customerOpenId.Trim() }, {"staff_accept_open_id", "varchar", staffOpenId.Trim() },
            {"scheduled_finish_date_time", "datetime", scheduledFinishTime.ToString() }, {"associate_card_no", "varchar", cardNo.Trim() },
            {"extend_service", "text", extendService.Trim() } });
        if (i == 1)
        {
            try
            {
                DataTable dt = DBHelper.GetDataTable(" select max(id) from  skis_maintain_task ");
                if (dt.Rows.Count > 0)
                {
                    taskId = int.Parse(dt.Rows[0][0].ToString());
                }
                dt.Dispose();
            }
            catch
            {

            }
        }
        return taskId;
    }
}