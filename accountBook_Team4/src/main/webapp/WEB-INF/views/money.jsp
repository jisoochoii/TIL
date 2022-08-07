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
	
	/* 지수 */
	// 페이지 넘어왔을때 현재 사용한 총 금액이 min설정값보다 낮을때 경고창 띄워주기
	let money = "${MaxBudget}".split(",").join("")-"${totalSpendBudget}".split(",").join("");
	let warn = document.getElementById("alert");
	let minBudget = "${MinBudget}".split(",").join("");
	if(b == 0){
		if(minBudget>money){//예산이 min 이하 0 이상일때(잔여)
			if(money>0){
				warn.innerHTML = "<i color=\"red\"class=\"fa-solid fa-circle-exclamation\"></i>"
							+" 설정하신 총 예산 금액까지</br> &nbsp;&nbsp;&nbsp;&nbsp;"+money.toLocaleString()+"원 남았습니다";
			}else{//총 예산보다 사용한 돈이 더 많을때(초과)
				money = Math.abs(money);
				warn.innerHTML = "<i color=\"red\"class=\"fa-solid fa-circle-exclamation\"></i>"
				+" 설정하신 총 예산 금액을</br> &nbsp;&nbsp;&nbsp;&nbsp;"+money.toLocaleString()+"원 초과했습니다";
			}
		}
	}
	// 당월로 달력 기본 설정
	document.getElementById('month').value= new Date().toISOString().slice(0, 7);
}

// 슬기 - 페이지 이동
function movePage(jobCode) {
	let form = document.getElementsByName("serverForm")[0];
	form.action = jobCode;
	form.method = "get";

	form.submit();
}
let i = 0;
// 지수 - 각각 예산 카테고리를 선택했을때 배경을 어둡게 바꿔주고 수정, 삭제버튼에  해당 카테고리의 정보보내기
function changeInfo(code){ //code=순번:MMCODE:MOCODE:MONAME:MOTOTAL
	let info = code.split(":");
	let moneyList = document.getElementById("moneyList");
	let child = moneyList.childNodes;
	let num = info[0];

	let a = 1;
	// 하나의 카테고리를 선택했을때 걔만 배경을 어둡게 해주고 나머지 애들은 선택되지않은상태로 돌리는 반복문
	// 이거안해주면 선택하고 다른애선택했을때 전에 선택한 애의 배경이 바뀌지않음
	if(i==0){/* 전역변수로 i=0으로 선언해줌. 처음에 페이지 방식으로 불러올때 id=moneyList에 el방식으로 삽입했기때문에 후에 ajax방식으로 innerText했을때와 chilenode의 갯수가 달라서 */
	for(idx=0;idx<child.length-2;idx++){
		if(a == num){
			if(child[a].className=="barDiv"){
				child[a].className="selected";
			}else{
				child[a].className="barDiv";
			}
		}else{
			child[a].className="barDiv";
		}
		a++;
	}
	}else{//첫페이지가 아닐 때
		for(idx=0;idx<child.length;idx++){
			if(a == num){

				if(child[a-1].className=="barDiv"){
					child[a-1].className="selected";
				}else{
					child[a-1].className="barDiv";
				}
			}else{
				child[a-1].className="barDiv";
			}
			a++;
		}
	}

	let upd = document.getElementById("upd");
	let del = document.getElementById("del");
	
	upd.innerHTML = "";
	upd.innerHTML = "<div onclick=\"updBueget(\'"+code+"\')\" class='btns fa-solid fa-gear'></div>";
	
	del.innerHTML = "";
	del.innerHTML = "<div onclick=\"delBueget(\'"+code+"\')\" class='btns fa-solid fa-trash-can'></div>";
}
// 지수 - 예산카테고리 수정
function updBueget(code){//code=순번:MMCODE:MOCODE:MONAME:MOTOTAL
	let info = code.split(":");
	let modalBox = document.querySelector("#modalBox");
	modalBox.style.display = "block";
	
	const modal = document.querySelector(".modalBox");
	let modalTitle = document.getElementById("modalTitle");
	let modalContent = document.getElementById("modalContent");

	modalTitle.innerText = "수정";
	modalContent.innerHTML = "<div>카테고리 이름</div>"
		+"<input id='moneyName' maxlength='10' value=\'"+info[3]+"\' type='text'/>"
		+ "<div>예산 금액</div>"
		+"<input id='moneyBudget' maxlength='30' value=\'"+info[4]+"\' onkeyup=\"inputNumberFormat(this)\" type='text'/>"
		+ "<input type='button' class = 'btnS' value='확인' onclick=\"confirmUpd(\'"+code+"\')\"/>"
		+"<input type ='button' id = 'settingCancel' class = 'btnC' value = '취소' onClick = 'cancel()'' />";

}
// 지수 - 예산카테고리 수정 유효성 체크
function confirmUpd(code){//code=순번:MMCODE:MOCODE:MONAME:MOTOTAL
	let ncode = code.split(",").join(""); //수정할땐 예산값을 가져가는데 숫자에 ,가 있으므로 빼주는작업
	let info = ncode.split(":");
	let moneyName = document.getElementById("moneyName").value;
	let moneyBudget = document.getElementById("moneyBudget").value.split(",").join("");
	
	//콜백함수로 보내기 폼데이터 postAjaxJson
	let clientData = "MMCODE="+info[1]+"&MOCODE="+info[2]+"&MONAME=" + moneyName +"&MOTOTAL="+moneyBudget;
	postAjaxJson("UpdMoney", clientData, "callBackSetList");

}
// 지수 - 예산카테고리 삭제
function delBueget(code){ //code=순번:MMCODE:MOCODE:MONAME:MOTOTAL
	let info = code.split(":");
	let modalBox = document.querySelector("#modalBox");
	modalBox.style.display = "block";

	const modal = document.querySelector(".modalBox");
	let modalTitle = document.getElementById("modalTitle");
	let modalContent = document.getElementById("modalContent");

	modalTitle.innerText = "삭제";
	modalContent.innerHTML = "<div>\'"+info[3]+"\' 카테고리를</div>"
			+ "<div>삭제하시겠습니까?</div>"
			+ "<input type='button' class = 'btnS' value='확인' onclick=\"confirmDel(\'"+code+"\')\"/>"
			+"<input type ='button' id = 'settingCancel' class = 'btnC' value = '취소' onClick = 'cancel()'' />";
}
// 지수 - 예산카테고리 삭제정보 서버보내기
function confirmDel(code){//code=순번:MMCODE:MOCODE:MONAME:MOTOTAL
	let info = code.split(":");
	let clientData = "MMCODE="+info[1]+"&MOCODE="+info[2]+"&MONAME="+info[3];
	postAjaxJson("DelMoney", clientData, "callBackSetList");
}
// 지수 - 예산카테고리 추가
function insBueget(){
	let modalBox = document.querySelector("#modalBox");
	modalBox.style.display = "block";

	const modal = document.querySelector(".modalBox");
	let modalTitle = document.getElementById("modalTitle");
	let modalContent = document.getElementById("modalContent");

	modalTitle.innerText = "추가";
	modalContent.innerHTML = "<div>카테고리 이름</div>"
			+"<input id='moneyName' maxlength='10' type='text'/>"
			+ "<div>예산 금액</div>"
			+"<input id='moneyBudget' maxlength='30' onkeyup=\"inputNumberFormat(this)\" type='text'/>"
			+ "<input type='button' class = 'btnS'  value='확인' onclick=\"confirmIns()\"/>"
			+"<input type ='button' id = 'settingCancel' class = 'btnC' value = '취소' onClick = 'cancel()'' />";

}
// 지수 - 예산카테고리 추가 유효성검사
function confirmIns(){
	let moneyName = document.getElementById("moneyName").value;
	let moneyBudget = document.getElementById("moneyBudget").value.split(",").join("");
	
	//콜백함수로 보내기 폼데이터 postAjaxJson
	let clientData = "MONAME=" + moneyName +"&MOTOTAL="+moneyBudget;
	postAjaxJson("InsMoney", clientData, "callBackSetList");
}
// 지수 - 추가, 수정, 삭제시 새로운 MONEYLIST를 만들어줄 콜백함수
function callBackSetList(ajaxData){
	let info = JSON.parse(ajaxData);
	i++;
	let moneyList = document.getElementById("moneyList");
	let monthBudget = document.getElementById("monthBudget");
	let cerentExp = document.getElementById("cerentExp");
	
	moneyList.innerHTML = "";
	monthBudget.innerHTML = "";
	cerentExp.innerHTML = "";
	
	moneyList.innerHTML = info.moList;
	monthBudget.innerHTML = info.MaxBudget;
	cerentExp.innerHTML = info.totalSpendBudget;
	
	alert(info.message);
	cancel();
	
}
// 지수 - 총 예산금액 설정
function changTotalBudget(){
	console.log("changTotalBudget");
	
	let modalBox = document.querySelector("#modalBox");
	modalBox.style.display = "block";

	const modal = document.querySelector(".modalBox");
	let modalTitle = document.getElementById("modalTitle");
	let modalContent = document.getElementById("modalContent");

	modalTitle.innerText = "총 예산금액 설정";
	modalContent.innerHTML = "<div>총 예산금액을 설정하세요</div>"
			+ "<input id='totalBudget' maxlength='30' onkeyup=\"inputNumberFormat(this)\" type='text' placeholder='예산금액 입력'/>"
			+ "<input type='button' class = 'btnS' value='확인' onclick='confirmBg()'/>"
			+"<input type ='button' id = 'settingCancel' class = 'btnC' value = '취소' onClick = 'cancel()'' />";

}
//지수 - 최소 예산금액 설정
function changMinBudget(){
	console.log("changMinBudget");
	
	let modalBox = document.querySelector("#modalBox");
	modalBox.style.display = "block";

	const modal = document.querySelector(".modalBox");
	let modalTitle = document.getElementById("modalTitle");
	let modalContent = document.getElementById("modalContent");

	modalTitle.innerText = "최소 예산금액 설정";
	modalContent.innerHTML = "<div>최소 예산금액을 설정하세요</div>"
			+ "<input id='minBudget' maxlength='30' onkeyup=\"inputNumberFormat(this)\" type='text' placeholder='예산금액 입력'/>"
			+ "<input type='button' class = 'btnS' value='확인' onclick='confirmMinBg()'/>"
			+"<input type ='button' id = 'settingCancel' class = 'btnC' value = '취소' onClick = 'cancel()'' />";

}
// 지수 - 총 예산금액 설정시 유효성검사
function confirmBg(){ //숫자인지 아닌지 유효성 검사 후 ajax로 보냄
	let totalBudget = document.getElementById("totalBudget");

	//postAjaxJson
	let clientData = "TMMAX=" + totalBudget.value.split(",").join("");
	postAjaxJson("ChangeTotalBudget", clientData, "callBackTbj");

}
//지수 - 최소 예산금액 설정시 유효성검사
function confirmMinBg(){ //숫자인지 아닌지 유효성 검사 후 ajax로 보냄
	let minBudget = document.getElementById("minBudget");

	let clientData = "TMMIN=" + minBudget.value.split(",").join("");
	postAjaxJson("ChangeMinBudget", clientData, "callBackMbj");

}
let b = 0;
// 지수 - 총예산 변경용 콜백함수
function callBackTbj(ajaxData){
	let totalBudget = JSON.parse(ajaxData);
	let monthBudget = document.querySelector(".monthBudget");
	monthBudget.innerHTML = totalBudget.tmmax+"원";
	b++;

	//예산 경고 띄워주기
	let money = (totalBudget.status).split(',').join(""); // 3,000,000으로 와서 ,를 빼주어야 값 비교가 가능함
	let warn = document.getElementById("alert");
	warn.innerHTML = "";

	if(totalBudget.tmmin > money) {
		if( money>0 ){//예산이 min 이하 0 이상일때(잔여)
			money = Math.abs(money);
			warn.innerHTML = "<i color=\"red\"class=\"fa-solid fa-circle-exclamation\"></i>"
				+" 설정하신 총 예산 금액까지</br> &nbsp;&nbsp;&nbsp;&nbsp;"+money.toLocaleString()+"원 남았습니다";
		}else{//총 예산보다 사용한 돈이 더 많을때(초과)
			money = Math.abs(money);
			warn.innerHTML = "<i color=\"red\"class=\"fa-solid fa-circle-exclamation\"></i>"
			+" 설정하신 총 예산 금액을</br> &nbsp;&nbsp;&nbsp;&nbsp;"+money.toLocaleString()+"원 초과했습니다";

		}
	}
	alert(totalBudget.message);
	cancel();
}
// 지수 - 최소예산 변경용 콜백함수
function callBackMbj(ajaxData){
	let totalBudget = JSON.parse(ajaxData);
	let monthMinBudget = document.querySelector(".monthMinBudget");
	monthMinBudget.innerHTML = totalBudget.tmmin+"원";
	b++;
	
	//예산 경고 띄워주기
	let money = (totalBudget.status).split(',').join(""); // 3,000,000으로 와서 ,를 빼주어야 값 비교가 가능함
	let warn = document.getElementById("alert");
	warn.innerHTML = "";
	if(totalBudget.tmmin > money) {
		if( money>0 ){//예산이 min 이하 0 이상일때(잔여)
			money = Math.abs(money);//숫자로 만들어줌
			warn.innerHTML = "<i color=\"red\"class=\"fa-solid fa-circle-exclamation\"></i>"
				+" 설정하신 총 예산 금액까지</br> &nbsp;&nbsp;&nbsp;&nbsp;"+money.toLocaleString()+"원 남았습니다";
		}else{//총 예산보다 사용한 돈이 더 많을때(초과)
			money = Math.abs(money);
			warn.innerHTML = "<i color=\"red\"class=\"fa-solid fa-circle-exclamation\"></i>"
			+" 설정하신 총 예산 금액을</br> &nbsp;&nbsp;&nbsp;&nbsp;"+money.toLocaleString()+"원 초과했습니다";
		}
	}
	alert(totalBudget.message);
	cancel();
}

// 취소 or 작업 완료 후 창끄기
function cancel() {
	let modalContent = document.getElementById("modalContent");
	modalContent.innerHTML =""; 
	let modalTitle = document.getElementById("modalTitle");
	modalTitle.innerText = "";
	let modalBox = document.querySelector("#modalBox");
	modalBox.style.display = "none";
	console.log("cancel");
}

</script>
</head>
<body onload="init()">
    <div id="header">
        <div id="yearBox"><input id="month" type="month" ></div>
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
                <div class="leftTopright" style="margin-top: 6px;display: flex;">
                	<div id="plus"><div onclick="insBueget()"class="btns fa-solid fa-plus"></div></div>
					<div id="upd"><div class="btns fa-solid fa-gear"></div></div>   
                    <div id="del"><div class="btns fa-solid fa-trash-can"></div></div>
                </div>
            </div>
            <div id="moneyList" class="leftBoxContent">
            	${moList}
            	${nmoList}
            </div>
        </div>
        <div class="rightBox">
            <div class="monthBudgetT"><h1>8월 총 예산</h1><div onclick="changTotalBudget()" class="btns totalBgSet fa-solid fa-gear"></div></div>
            <div id="monthBudget" class="monthBudget" style="color: gray;">${MaxBudget}원</div>
            <div class="monthBudgetT"><h2>8월 최소예산</h2><div onclick="changMinBudget()" class="btns totalBgSet fa-solid fa-gear"></div></div>
            <div id="monthMinBudget" class="monthMinBudget" style="color: gray;">${MinBudget}원</div>
            <div  class="cerentBedgetStat">
                <div><h2>현재 총 지출액</h2></div>
                <div id="cerentExp" class="cerentExp">${totalSpendBudget}원</div>
            </div>
            <div id="alert" class="alert" ></div>
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