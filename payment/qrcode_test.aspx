<%@ Page Language="C#" %>

<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        ThoughtWorks.QRCode.Codec.QRCodeEncoder qrCode = new ThoughtWorks.QRCode.Codec.QRCodeEncoder();
        System.Drawing.Bitmap bt = qrCode.Encode("weixin://wxpay/bizpayurl?pr=YLXWxil", System.Text.Encoding.UTF8);
        //System.IO.StreamWriter sw = new System.IO.StreamWriter(;
       
        bt.Save(Server.MapPath("test.bmp"), System.Drawing.Imaging.ImageFormat.Bmp);

    }
</script>
