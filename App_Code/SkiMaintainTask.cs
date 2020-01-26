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
    public SkiMaintainTask()
    {
        //
        // TODO: Add constructor logic here
        //
    }

    public static int CreateNewTask(string customerOpenId, string staffOpenId, int skiId, int edge, bool candle, bool fixBoard, string memo, DateTime scheduledFinishTime)
    {
        int taskId = 0;
        int i = DBHelper.InsertData("ski_maintain_task", new string[,] { {"ski_id", "int", skiId.ToString() }, {"edge", "int", edge.ToString() }, 
            {"candle", "int", (candle? "1" : "0")}, {"fix_board", "int", (fixBoard? "1":"0") }, {"memo", "varchar", memo.Trim() },
            {"customer_open_id", "varchar", customerOpenId.Trim() }, {"staff_accept_open_id", "varchar", staffOpenId.Trim() },
            {"scheduled_finish_date_time", "datetime", scheduledFinishTime.ToString() } });
        if (i == 1)
        {
            try
            {
                DataTable dt = DBHelper.GetDataTable(" select max(id) from  ski_maintain_task ");
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