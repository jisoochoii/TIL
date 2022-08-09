<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>AccountBook :: Money</title>
<script src="https://use.fontawesome.com/releases/v6.1.1/js/all.js"></script>
<script src="/resources/js/access.js"></script>
<script src="/resources/js/main.js"></script>
<script src="/resources/js/common.js"></script>
<style>@import url("/resources/css/common.css");</style>
<style>@import url("/resources/css/main.css");</style>
<style>@import url("/resources/css/money.css");</style>

<style>  
.barDiv{
	
}
.container{
	width : 100%;
	height : 100%;}
.btns{
	margin-right :1rem;
}
.totalBgSet{
	float:right;
}
.selected{
	background: gainsboro;
}
#alert{
	 margin-top : 2rem;
	 color : red;
}
</style>

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
	document.getElementById('MONTH').value= "${MONTH}";
}

// 슬기 - 페이지 이동
function movePage(jobCode) {
	let form = document.getElementsByName("serverForm")[0];
	form.action = jobCode;
	form.method = "post";

	form.submit();
}

// 지수 - 캘린더 월 선택시 페이지이동
function changeMonth(){
	let form = document.getElementsByName("serverForm")[0];
    
	// 지수 - 선택한 달 서버로 보내주기
	let month = document.getElementById("MONTH").value;
	
	form.appendChild(createHidden("MONTH", month));

    form.action = "Money";
    form.method = "post";

    form.submit();
}
</script>
</head>
<body onload="init()">
    <div id="header">
        <div id="yearBox"><input id="MONTH" type="month" onChange="changeMonth()" ></div>
        <div id="userInfo">사용자 정보<i class="fa-solid fa-user"></i></div>
        <div id="setting"><i class="fa-solid fa-gear"></i></div>
        <input type="button" value = "로그아웃" class = "btn" onclick = "logout()" />	<!-- 로그아웃 -->
    </div>

<!-- 네비게이션 -->
	<div id = "nvg" style="display:flex;justify-content:space-evenly">
		<div id = "nvgMain" onclick="movePage('Main')">메인</div>
		<div id = "nvgInout" onclick="movePage('Inout')">입력</div>
		<div id = "nvgMoney" onclick="movePage('Money')" >예산설정</div>
		<div id = "nvgSetting" onclick="movePage('Setting')">설정</div>
	</div>

	<div id="container">
        		<div class="leftBox">
            <div class="leftTop">
                <div class="leftTopleft" style="width:5rem;">&nbsp;&nbsp;CATEGORY</div>
                <div class="leftTopright" style="margin-top: 6px;display: flex;"></div>
            </div>
            <div id="moneyList" class="leftBoxContent">
            	${moList}
            </div>
        </div>
        <div class="rightBox">
               <div><h1>총 지출액</h1></div>
               <div id="cerentExp" class="cerentExp"><h2>${totalSpendBudget}원</h2></div>
        </div>
	</div>
	<!-- 설화 - 모달박스 -->
	<div id = "modalBox">
		<div id = "modalBoby">
			<div id = "modalTitle">
			</div>
			<div id = "modalContent">
			</div>
			<div id = "modalBottom">
			</div>
		</div>
	</div>
	<form name="serverForm"></form>
	<div id="footer">

	</div>
</body>
</html>