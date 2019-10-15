using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Drawing;
using System.Drawing.Drawing2D;
using System.Drawing.Imaging;
using System.IO;

/// <summary>
/// Summary description for BitmapImage
/// </summary>
public class BitmapImage
{
    public BitmapImage()
    {
        //
        // TODO: Add constructor logic here
        //

    }


    public static MemoryStream ImageCheck(string checkCode)
    {
        Random random = new Random();
        //随机产生4位随机数
        //string checkCode = random.Next(1000, 9999).ToString();
        //Bitmap是用来指定初始化时文本的大小
        Bitmap image = new Bitmap((int)Math.Ceiling((checkCode.Length * 20.5)), 22);
        Graphics g = Graphics.FromImage(image);
        try
        {

            g.Clear(Color.White);//清空图片背景色
            //画图片的背景噪音线这里是4条线
            for (int i = 0; i < 4; i++)
            {
                int x1 = random.Next(image.Width);
                int x2 = random.Next(image.Width);
                int y1 = random.Next(image.Height);
                int y2 = random.Next(image.Height);
                g.DrawLine(new Pen(Color.Black), x1, x2, y1, y2);
            }
            Font font = new Font("Arial", 12, FontStyle.Bold);
            //设置颜色，起始位置等参数
            LinearGradientBrush brush = new LinearGradientBrush(new Rectangle(0, 0, image.Width, image.Height), Color.Blue, Color.DarkRed, 1.2f, true);
            g.DrawString(checkCode, font, brush, 2, 2);
            //画图片的前景噪音点
            for (int i = 0; i < 100; i++)
            {
                int x = random.Next(image.Width);
                int y = random.Next(image.Height);
                image.SetPixel(x, y, Color.FromArgb(random.Next()));
            }
            //画图片噪音线
            g.DrawRectangle(new Pen(Color.Silver), 0, 0, image.Width - 1, image.Height - 1);
            MemoryStream ms = new MemoryStream();
            image.Save(ms, ImageFormat.Gif);
            return ms;
        }
        finally
        {
            g.Dispose();
            image.Dispose();
        }

    }
}