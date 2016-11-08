<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <!-- 新 Bootstrap 核心 CSS 文件 -->
    <link rel="stylesheet" href="css/bootstrap.min.css">
    <link rel="stylesheet" href="css/normalize.css" />
    <!-- 可选的Bootstrap主题文件（一般不用引入） -->
    <link rel="stylesheet" href="css/bootstrap-theme.min.css">
    <!-- jQuery文件。务必在bootstrap.min.js 之前引入 -->
    <script src="js/jquery.min.js"></script>
    <!-- 最新的 Bootstrap 核心 JavaScript 文件 -->
    <script src="js/bootstrap.min.js"></script>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <script type="text/javascript" >
        function select_ticket(id) {
            var ticket_array = document.getElementsByName("ticket");
            for(var i = 0 ; i < ticket_array.length ; i++) {
                var ticket = ticket_array[i];
                if (ticket.id == "ticket-" + id) {
                    ticket.className = "panel panel-danger";
                }
                else {
                    ticket.className = "panel panel-info";
                }
            }
        }
    </script>
</head>
<body>
    <div style="margin-left: 5px">
        <h1>龙珠兑换代金券</h1>
        <h6>你目前拥有龙珠：1236颗</h6>
        <div id="ticket-1" name="ticket" class="panel panel-info" style="width:350px" onclick="select_ticket('1')" >
            <div class="panel-heading">
                <h3 class="panel-title">1000龙珠兑换代金券100元</h3>
            </div>
            <div class="panel-body">
                <ul>
                    <li>从兑换之日起计算有效期300天。</li>
                    <li>可以用于购买打折商品。</li>
                    <li>每次消费使用一张。</li>
                    <li>使用面额不得超过消费金额的三分之一。</li>
                    <li>最终解释权归易龙雪聚所有。</li>
                </ul>
            </div>
        </div>
        <div id="ticket-2" name="ticket" class="panel panel-info" style="width:350px" onclick="select_ticket('2')"  >
            <div class="panel-heading">
                <h3 class="panel-title">2000龙珠兑换代金券200元</h3>
            </div>
            <div class="panel-body">
                <ul>
                    <li>从兑换之日起计算有效期300天。</li>
                    <li>可以用于购买打折商品。</li>
                    <li>每次消费使用一张。</li>
                    <li>使用面额不得超过消费金额的三分之一。</li>
                    <li>最终解释权归易龙雪聚所有。</li>
                </ul>
            </div>
        </div>
        <div id="ticket-3" name="ticket" class="panel panel-info" style="width:350px" onclick="select_ticket('3')" >
            <div class="panel-heading">
                <h3 class="panel-title">5000龙珠兑换代金券500元</h3>
            </div>
            <div class="panel-body">
                <ul>
                    <li>从兑换之日起计算有效期300天。</li>
                    <li>可以用于购买打折商品。</li>
                    <li>每次消费使用一张。</li>
                    <li>使用面额不得超过消费金额的三分之一。</li>
                    <li>最终解释权归易龙雪聚所有。</li>
                </ul>
            </div>
        </div>
        <input type="checkbox" />同意兑换，此操作不可逆。<br/>
        <button class="btn btn-danger" >兑换代金券</button>
    </div>
</body>
</html>
