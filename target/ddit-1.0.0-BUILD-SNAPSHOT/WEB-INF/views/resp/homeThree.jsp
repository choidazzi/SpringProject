<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<script src="/resources/js/jquery-3.6.0.js"></script>
<h1>homethree</h1>

<p><input type="text" name="bookId"value="3" /></p>
<button type="button" id="btnBookDetail">도서정보 확인</button>
<p>
    <textarea name="content" id="content" cols="30" rows="5"></textarea>
</p>
<script>
    $.ajax({
        url:'/resp/javaBeans',
        type:'get',
        data: 'json',
        success: function (res) {
            console.log("result: " + JSON.stringify(res));
        }
    })

    $("#btnBookDetail").on("click", function() {
        let bookId =  $("input[name='bookId']").val();
        let data = {
            "bookId": bookId
        }

        console.log("data: ", JSON.stringify(data));

        $.ajax({
            url: '/resp/ex1',
            type: 'get',
            data: data,
            dataType: "json",
            contentType:'application/json;charset=utf-8',
            success: function (res) {
                //console.log("res", res);
            }
        })

        $.ajax({
            url: '/resp/ex2',
            type: 'post',
            data: JSON.stringify(data),
            dataType: "json",
            contentType:'application/json;charset=utf-8',
            success: function (res) {
                console.log("Post: ", res);

                $("textarea[name='content']").val(res.content);
            }
        })
    })
</script>
