<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>AccountBook :: Main</title>
<script src="https://use.fontawesome.com/releases/v6.1.1/js/all.js"></script>
<script src="/resources/js/access.js"></script>
<script src="/resources/js/main.js"></script>
<style>@import url("/resources/css/common.css");</style>
<style>@import url("/resources/css/main.css");</style>
<script>
//페이지 로드 할 때 테마 바꿔주기
function init() {
	let themeCode = "${themeCode}".split(":");
	let header = document.getElementById("header");
	let container = document.getElementById("container");
	
	header.style.background = themeCode[0];
	header.style.color = themeCode[1];
	container.style.background = themeCode[2];
	container.style.color = themeCode[3];
	
	// 당월로 달력 기본 설정
	document.getElementById('MONTH').value= new Date().toISOString().slice(0, 7);

}
	// 슬기 - 페이지 이동
    function movePage(action) {
        let form = document.getElementsByName("serverForm")[0];
        
		// 지수 - 선택한 달 서버로 보내주기
		let month = document.getElementById("MONTH").value;
		
		form.appendChild(createHidden("MONTH", month));

        form.action = action;
        form.method = "post";

        form.submit();
    }
</script>
</head>
<body onload="init()">
 
    <div id="header">
        <div id="yearBox"><input id="MONTH" type="month"></div>
        <div id="userInfo">사용자 정보<i class="fa-solid fa-user"></i></div>
        <div id="setting"><i class="fa-solid fa-gear"></i></div>
    	<input type="button" value = "로그아웃" class = "btn" onclick="logout()" />	<!-- 로그아웃 -->
    </div>

    <div id="container">
        <div id="btns">
            <div id="btnInout" class="circleBtn" onclick="movePage('Inout')">입력</div>
            <div id="btnMoney" class="circleBtn" onclick="movePage('Money')">예산설정</div>
            <div id="btnSetting" class="circleBtn" onclick="movePage('Setting')">설정</div>
        </div>
    </div>

	   <form name="serverForm"></form>
    <div id="footer">
        
    </div>
</body>
</html>