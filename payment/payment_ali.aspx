<%@ Page Language="C#" %>
<%@ Import Namespace="Com.Alipay.Domain" %>
<%@ Import Namespace="Com.Alipay" %>
<%@ Import Namespace="Com.Alipay.Business" %>
<%@ Import Namespace="System.Drawing" %>
<%@ Import Namespace="ThoughtWorks" %>
<%@ Import Namespace="ThoughtWorks.QRCode" %>
<%@ Import Namespace="ThoughtWorks.QRCode.Codec" %>
<%@ Import Namespace="ThoughtWorks.QRCode.Codec.Data" %>
<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        Config.alipay_public_key = Server.MapPath("rsa_public_key.pem");
        Config.merchant_private_key = Server.MapPath("rsa_private_key.pem");
        Config.merchant_public_key = Server.MapPath("rsa_public_key.pem");
        IAlipayTradeService serviceClient = F2FBiz.CreateClientInstance(Config.serverUrl, Config.appId, Config.merchant_private_key, Config.version,
                            Config.sign_type, Config.alipay_public_key, Config.charset);
        AlipayTradePrecreateContentBuilder builder = BuildPrecreateContent();
        AlipayF2FPrecreateResult precreateResult = serviceClient.tradePrecreate(builder);
        //Response.Write(precreateResult.Status.ToString());
        DoWaitProcess(precreateResult);
    }

    private void DoWaitProcess( AlipayF2FPrecreateResult precreateResult )
    {
        //打印出 preResponse.QrCode 对应的条码
        Bitmap bt;
        string enCodeString = precreateResult.response.QrCode;
        QRCodeEncoder qrCodeEncoder = new QRCodeEncoder();
        qrCodeEncoder.QRCodeEncodeMode = QRCodeEncoder.ENCODE_MODE.BYTE;
        qrCodeEncoder.QRCodeErrorCorrect = QRCodeEncoder.ERROR_CORRECTION.H;
        qrCodeEncoder.QRCodeScale = 3;
        qrCodeEncoder.QRCodeVersion = 8;
        bt = qrCodeEncoder.Encode(enCodeString, Encoding.UTF8);
        Response.ContentType = "image/bitmap";
        bt.Save(Response.OutputStream, System.Drawing.Imaging.ImageFormat.Bmp);
        
        //this.Image1.ImageUrl = "~/images/" + filename;

        //轮询订单结果
        //根据业务需要，选择是否新起线程进行轮询
        //ParameterizedThreadStart ParStart = new ParameterizedThreadStart(LoopQuery);
        //Thread myThread = new Thread(ParStart);
        //object o = precreateResult.response.OutTradeNo;
        //myThread.Start(o);

    }

    private AlipayTradePrecreateContentBuilder BuildPrecreateContent()
    {
        //线上联调时，请输入真实的外部订单号。
        string out_trade_no = "";
        /*
        if (String.IsNullOrEmpty(WIDout_request_no.Text.Trim()))
        {
            out_trade_no = System.DateTime.Now.ToString("yyyyMMddHHmmss") + "0000" + (new Random()).Next(1, 10000).ToString();
        }
        else
        {
            out_trade_no = WIDout_request_no.Text.Trim();
        }
        */
        out_trade_no = Util.GetTimeStamp();
        AlipayTradePrecreateContentBuilder builder = new AlipayTradePrecreateContentBuilder();
        //收款账号
        builder.seller_id = Config.pid;
        //订单编号
        builder.out_trade_no = out_trade_no;
        //订单总金额
        builder.total_amount = "1";//WIDtotal_fee.Text.Trim();
        //参与优惠计算的金额
        //builder.discountable_amount = "";
        //不参与优惠计算的金额
        //builder.undiscountable_amount = "";
        //订单名称
        builder.subject = "test" + out_trade_no.Trim();//WIDsubject.Text.Trim();
        //自定义超时时间
        builder.timeout_express = "5m";
        //订单描述
        builder.body = "";
        //门店编号，很重要的参数，可以用作之后的营销
        builder.store_id = "测试门店";
        //操作员编号，很重要的参数，可以用作之后的营销
        builder.operator_id = "苍杰";
        
        //传入商品信息详情
        //List<GoodsInfo> gList = new List<GoodsInfo>();
        //GoodsInfo goods = new GoodsInfo();
        //goods.goods_id = "goods id";
        //goods.goods_name = "goods name";
        //goods.price = "0.01";
        //goods.quantity = "1";
        //gList.Add(goods);
        //builder.goods_detail = gList;

        //系统商接入可以填此参数用作返佣
        //ExtendParams exParam = new ExtendParams();
        //exParam.sysServiceProviderId = "20880000000000";
        //builder.extendParams = exParam;

        return builder;

    }

</script>
