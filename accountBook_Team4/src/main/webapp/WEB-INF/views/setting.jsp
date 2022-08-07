<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>AccountBook :: Setting</title>
<script src="https://use.fontawesome.com/releases/v6.1.1/js/all.js"></script>
<script src="/resources/js/access.js"></script>
<script src="/resources/js/main.js"></script>
<script src="/resources/js/common.js"></script>
<style>@import url("/resources/css/common.css");</style>
<style>@import url("/resources/css/main.css");</style>
<style>@import url("/resources/css/setting.css");</style>
<script type="text/javascript">
	// 설화 - 페이지 불러올 떄 모달창과 테마 변경
	function init() {
		//페이지 로드 할 때 테마 바꿔주기
		let themeCode = "${themeCode}".split(":");
		let header = document.getElementById("header");
		let container = document.getElementById("container");

		header.style.background = themeCode[0];
		header.style.color = themeCode[1];
		container.style.background = themeCode[2];
		container.style.color = themeCode[3];
		
		// 모달박스 활성화
		let modalBox = document.querySelector("#modalBox");
		modalBox.style.display = "block";

		document.getElementById("cuTable").style.display = "none";
	}

	/* 지수 - 설정페이지 버튼 이동 */
	function cngPassword() {
		console.log("cngPassword");
		const modal = document.querySelector(".modalBox");
		let modalTitle = document.getElementById("modalTitle");
		let modalContent = document.getElementById("modalContent");

		modalTitle.innerText = "비밀번호 변경";
		modalContent.innerHTML = "<div>현재 비밀번호를 입력하세요</div>"
				+ "<input id='password' type='password' placeholder='비밀번호 입력'/>"
				+ "<input type='button' class = 'btnS' value='확인' onclick='confirmPw()'/>";

	}
	
	// 지수 - 현재비밀번호 입력
	function confirmPw() {
		let password = document.getElementById("password");
		//비밀번호 유효성 검사
		if (isCharCheck(password.value, true)) {
			if (!isCharLengthCheck(password.value, 6)) {
				alert("패스워드는 6자 이상이어야 합니다.");
				password.value = "";
				password.focus();
				return;
			}
		} else {
			alert("영문 대소문자, 숫자, 특수문자 중 3종류 이상의 문자를 사용해 주세요.");
			password.value = "";
			password.focus();
			return;
		}

		//콜백함수로 보내기 폼데이터 postAjaxJson
		let clientData = "MMPASSWORD=" + password.value;
		postAjaxJson("ConfirmPw", clientData, "changePw");
	}
	
	// 지수 - 기존 비밀번호 확인 후 통과되면 새로운 비밀번호 입력받기
	function changePw(ajaxData) {
		const Data = JSON.parse(ajaxData);
		let password = document.getElementById("password");

		// 기존비밀번호 db에서 불러와 비교했는데 틀렸을 경우
		if (Data.mmmessage == "불일치") {
			alert("비밀번호가 틀렸습니다. 다시 입력해주세요.");
			password.value = "";
			return;
		}

		// 일치한 경우
		let modalContent = document.getElementById("modalContent");
		modalContent.innerHTML = "<div>새로운 비밀번호를 입력하세요</div>"
				+ "<input name='password1' type='password' placeholder='비밀번호 입력'/>"
				+ "<div>비밀번호를 한번 더 입력하세요</div>"
				+ "<input name='password2' type='password' placeholder='비밀번호 입력'/>"
				+ "<input type='button' class = 'btnS' value='확인' onclick='updPw()'/>";

	}
	
	// 지수 - 업데이트할 비밀번호 유효성검사 후 서버에 보내기
	function updPw() {
		let password1 = document.getElementsByName("password1")[0];
		let password2 = document.getElementsByName("password2")[0];

		//비밀번호 유효성 검사
		if (isCharCheck(password1.value, true)) {
			if (!isCharLengthCheck(password1.value, 6)) {
				alert("패스워드는 6자 이상이어야 합니다."); //max만 체크
				password1.value = ""; //초기화
				password1.focus();
				return;
			}
		} else {
			alert("영문 대소문자, 숫자, 특수문자 중 3종류 이상의 문자를 사용해 주세요.");
			password1.value = "";
			password1.focus();
			return;
		}
		if (isCharCheck(password2.value, true)) {
			if (!isCharLengthCheck(password2.value, 6)) {
				alert("패스워드는 6자 이상이어야 합니다."); //max만 체크
				password2.value = ""; //초기화
				password2.focus();
				return;
			}
		} else {
			alert("영문 대소문자, 숫자, 특수문자 중 3종류 이상의 문자를 사용해 주세요.");
			password2.value = "";
			password2.focus();
			return;
		}

		//password1과 2가 같아야함
		if (password1.value == password2.value) {
			//콜백함수로 보내기 폼데이터 postAjaxJson
			let clientData = "MMPASSWORD=" + password1.value;
			postAjaxJson("ChangePw", clientData, "seccessUpdPw");
		} else {
			alert("비밀번호가 일치하지않습니다.");
			password2.focus();
			return;
		}

	}
	
	// 지수 - 서버에 패스워드 변경 후 결과값 띄워주고 다시 설정메뉴 띄우기
	function seccessUpdPw(ajaxData) {
		const Data = JSON.parse(ajaxData);
		alert(Data.mmmessage);

		let modalContent = document.getElementById("modalContent");
		modalContent.innerHTML = "<input type = 'button' id = 'Password' class = 'btnS' value = '비밀번호 변경' onClick = 'cngPassword()' />"
				+ "<input type = 'button' id = 'Theme' class = 'btnS' value = '테마 변경' onClick = 'cngTheme()' />"
				+ "<input type = 'button' id = 'Account' class = 'btnS' value = '계정과목 변경' onClick = 'cngAccount()' />"
				+ "<input type = 'button' id = 'Customer' class = 'btnS' value = '거래처 변경' onClick = 'cngCustomer()' />";
		cancel();
		//다시 설정메뉴 불러오기
		let modalBox = document.querySelector("#modalBox");

		modalBox.style.display = "block";
	}

	//테마변경 클릭시 :: innerHTML 쏴주던가 펼치던가
	function cngTheme() {
		console.log("cngTheme");
		// 모달창 끄기
		cancel();

		// 네비 보여주기
		let cngTheme = document.getElementById("cngTheme");
		cngTheme.style.display = "block";

		// 컨테이너에 html 뿌리기
		/* 		let container = document.getElementById("container");

		 let cngTheme = "<div id='cngTheme'>";
		 cngTheme += "<div id = 'window'><p>운영체제와 동일한 테마 적용 : OFF</p>";
		 cngTheme += "<label class='switch'><input type='checkbox'><span class='slider round'></span>";
		 cngTheme += "</label><p>ON</p></div>";
		 cngTheme += "<div id = 'darkMode'><p>다크모크 : OFF</p><label class='switch'><input type='checkbox'>";
		 cngTheme += "<span class='slider round'></span></label><p>ON</p></div>";
		 cngTheme += "<div id = 'colorMode'><h3>Select your Theme</h3>";
		 cngTheme += "<input type = 'button' value = '핑크' onClick = cngColor('pink')>";
		 cngTheme += "<input type = 'button' value = '옐로우' onClick = cngColor('yellow')>";
		 cngTheme += "<input type = 'button' value = '블루' onClick = cngColor('blue')>";
		 cngTheme += "<input type = 'button' value = '퍼플' onClick = cngColor('purple')>";
		 cngTheme += "<input type = 'button' value = '그린' onClick = cngColor('grean')>";
		 cngTheme += "</div></div>";

		 container.innerHTML = cngTheme; */
	}

	// 윤주 - 계정과목
	function cngAccount() {
		cancel();
	}

	// 슬기 - 거래처 서버로 전송
	function cngCustomer() {
		getAjaxJson("CustomerForm", "", "setCustomer");

		cancel();
	}

	// 슬기 - 거래처 설정
	function setCustomer(ajaxData) {
		const map = JSON.parse(ajaxData);
		const customerList = map.CustomerList;
		const moneyList = map.MoneyList;
		document.getElementById("cuTable").style.display = "block";
		let cuBody = document.getElementsByClassName("cuBody")[0];
		cuBody.innerText = "";

		console.log(customerList);
		if (customerList.length > 1) {
			for (idx = 0; customerList.length; idx++) {
				let pi = "<div class='cuItem code'><input type='text' name='CUCODE' value='"+customerList[idx].cucode+"' readOnly class='cuInput'/></div>";
				pi += "<div class='cuItem name'><input type='text' name='CUNAME' "
						+ (customerList[idx].cuname != null ? ("value='"
								+ customerList[idx].cuname + "'")
								: "placeholder='거래처명입력'")
						+ "' class='cuInput' /></div>";
				pi += "<div class='cuItem mocode'><select name='MOCODE'>";
				if (customerList[idx].MOCODE != ""
						&& customerList[idx].MOCODE != null)
					pi += "<option value='"+customerList[idx].mocode+"'>";
				else
					pi += "<option disabled selected value=''>선택안함</option>";
				for (moIdx = 0; moIdx < moneyList.length; moIdx++) {
					pi += "<option value='"+moneyList[moIdx].mocode+"'>"
							+ moneyList[moIdx].moname + "</option>";
				}
				pi += "</select></div>";
				if (idx != customerList.length - 1) {
					pi += "<div class='cuItem cbtn'><button onclick='delCustomer(this)'>삭제</button></div>";
				} else
					pi += "<div class='cuItem cbtn'></div>";

				let div = createInputDiv(null, pi, null, "cuRow");
				cuBody.appendChild(div);
			}
		} else {
			let pi = "<div class='cuItem code'><input type='text' name='CUCODE' value='"+customerList[0].cucode+"' readOnly class='cuInput' /></div>";
			pi += "<div class='cuItem name'><input type='text' name='CUNAME' class='cuInput' /></div>";
			pi += "<div class='cuItem mocode'><select name='MOCODE'>";
			pi += "<option disabled selected value=''>선택안함</option>";
			for (moIdx = 0; moIdx < moneyList.length; moIdx++) {
				pi += "<option value='"+moneyList[moIdx].mocode+"'>"
						+ moneyList[moIdx].moname + "</option>";
			}
			pi += "</select></div>";
			pi += "<div class='cuItem cbtn'></div>";

			let div = createInputDiv(null, pi, null, "cuRow");
			cuBody.appendChild(div);
		}

	}

	// 슬기 - 거래처 수정
	function updCustomer(obj) {
		//db에서 cucode조회 후 비교, 존재하는 코드면 update실행 후 밑에 빈칸 추가 안함, 아니면 insert실행 후 밑에 빈칸 추가
		if (obj.children[1].value != "" && obj.children[1].value != null) {
			let clientData = "CUCODE=" + obj.children[0].value + "&CUNAME="
					+ obj.children[1].value + "&MOCODE="
					+ obj.children[2].value;
			postAjaxJson("UpdateCustomer", clientData, "setCustomer");
		} else {
			alert("거래처명을 입력하세요");
		}
	}
	
	// 슬기 - 거래처 삭제
	function delCustomer(obj) {
		let result = confirm("삭제하시겠습니까?");
		//삭제 갈겨
		if (result) {
			let clientData = "CUCODE=" + obj.parentNode.childNodes[0].value
					+ "&CUNAME=" + obj.parentNode.childNodes[1].value
					+ "&MOCODE=" + obj.parentNode.childNodes[2].value;
			alert(clientData);
			postAjaxJson("DeleteCustomer", clientData, "setCustomer");
		} else {
			return;
		}
	}

	// 언제든 취소했을때 처음 메뉴로 돌아가기
	function cancel() {
		let modalContent = document.getElementById("modalContent");
		modalContent.innerHTML = "<input type = 'button' id = 'Password' class = 'btnS' value = '비밀번호 변경' onClick = 'cngPassword()' />"
				+ "<input type = 'button' id = 'Theme' class = 'btnS' value = '테마 변경' onClick = 'cngTheme()' />"
				+ "<input type = 'button' id = 'Account' class = 'btnS' value = '계정과목 변경' onClick = 'cngAccount()' />"
				+ "<input type = 'button' id = 'Customer' class = 'btnS' value = '거래처 변경' onClick = 'cngCustomer()' />";
		let modalTitle = document.getElementById("modalTitle");
		modalTitle.innerText = "설정";
		let modalBox = document.querySelector("#modalBox");
		modalBox.style.display = "none";
		console.log("cancel");
	}

	// 슬기 - 페이지 이동
	function movePage(jobCode) {
		let form = document.getElementsByName("serverForm")[0];
		form.action = jobCode;
		form.method = "get";

		form.submit();
	}
</script>
<style>
#modalBox {
 	position: absolute; 
	top: 0;
	left: 0;
	width: 100%;
	height: 100%;
	display: none;
	background-color: rgba(0, 0, 0, 0.7);
}

#modalBoby {
 	position: absolute;
	width: 30%;
	height: 60%;
	top: 50%;
	left: 50%;
 	transform: translate(-50%, -50%); 
	background-color: #FFFFFF;
}

#modalTitle {
	display : flex;
	flex-direction: column;
	justify-content: center;
	width: 100%;
	height: 10%;
	font-size: 35px;
	text-align: center;
	font-weight: 800;
	/* 배경 그라데이션 */
	border:none;
	background: linear-gradient(to right top, rgb(64, 201, 247), rgb(205, 73, 253));
    color: #fff;
}

#modalContent {
	display : flex;
	flex-direction: column;
	justify-content: space-evenly;
	align-items: center;
	width: 100%;
	height: 70%;
}

#modalBottom {
	display : flex;
	flex-direction: column;
	justify-content: center;
	align-items: center;
	width: 100%;
	height: 20%;
}

/* 변경할 버튼들 - 테두리 그라데이션 */
.btnS {
    cursor: pointer;
  	width: 300px;
	height: 60px;
    color: #000000;
    font-size: 30px;
	font-weight: 700;
	/* 테두리 그라데이션 */
	border: 0.4rem solid transparent;
    border-radius: 0.8rem;
	background-image: linear-gradient(#ffffff, #ffffff), linear-gradient(to right top, rgb(64, 201, 247), rgb(205, 73, 253));
	background-origin: border-box;
	background-clip: padding-box, border-box;
}

/* 취소 버튼 - 배경 그라데이션 */
.btnC {
	bottom : 0;
    cursor: pointer;
  	width: 300px;
	height: 60px;
    font-size: 35px;
	font-weight: 800;
	/* 배경 그라데이션 */
	border:none;
	border-radius: 0.8rem;
	background: linear-gradient(to right top, rgb(64, 201, 247), rgb(205, 73, 253));
    color: #fff;
}

#reroad {
	top : 10px;
	float : right;
}
</style>
</head>
<body onLoad = "init()">
    <div id="header">
        <div id="yearBox"><input type="month"></div>
        <div id="userInfo">사용자 정보<i class="fa-solid fa-user fa-lg"></i></div>
        <div id="setting" onClick="init()"><i class="fa-solid fa-gear fa-lg"></i></div>
        <input type="button" value = "로그아웃" class = "btn" onclick = "logout()" />	<!-- 로그아웃 -->
    </div>
    
<!-- 설화 - 네비게이션 -->
	<div id = "nvg" style="display:flex;justify-content:space-evenly">
		<div id = "nvgMain" onclick="movePage('Main')">메인</div>
		<div id = "nvgInout" onclick="movePage('Inout')">입력</div>
		<div id = "nvgMoney" onclick="movePage('Money')" >예산설정</div>
		<div id = "nvgSetting" onclick="movePage('Setting')">설정</div>
	</div>

	<div id="container">
		<input type="button" value="설정" id="reroad" class="btn" onClick="init()" />

		<!-- 설화 - 테마 변경 시작 -->
		<div id="cngTheme" style="display: none">
			<!-- 토글 스위치 ON일 때 변환 -->
			<!-- 윈도우랑 동일 테마 -->
			<div id="window">
				<p>운영체제와 동일한 테마 적용 : OFF</p>
				<label class="switch"> <input type="checkbox"
					id="windowSystem" onClick="cngWindow()" /> <span
					class="slider round"></span>
				</label>
				<p>ON</p>
			</div>
			<!-- 다크모크 -->
			<!-- 	<div id="darkMode">
				<p>다크모크 : OFF</p>
				<label class="switch"> 
					<input type="checkbox" id = "darkSystem" onClick = "cngDark()"> 
					<span class="slider round"></span>
				</label>
				<p>ON</p>
			</div> -->

			<!-- 토글 테마 변경 스위치 -->
			<div id="colorMode">
				<h3>Select your Theme</h3>
				<input type="button" value="핑크" onClick="cngColor('pink')">
				<input type="button" value="옐로우" onClick="cngColor('yellow')">
				<input type="button" value="블루" onClick="cngColor('blue')">
				<input type="button" value="퍼플" onClick="cngColor('purple')">
				<input type='button' value='그린' onClick="cngColor('grean')">
			</div>
		</div>

		<div id="cuTable" style="display: none">
	    	<div class="cuHead">
	    		<div class="cuRow">
	    			<div class="cuHeader code">거래처 코드</div>
	    			<div class="cuHeader name">거래처 명</div>
	    			<div class="cuHeader mocode">예산 설정</div>
	    			<div class="cuHeader cbtn">삭제</div>
	    		</div>
	    	</div>
	    	<div class="cuBody"></div>
    	</div>

	</div>

    <!-- 설화 - 모달박스 -->
	<div id = "modalBox">
		<div id = "modalBoby">
			<div id = "modalTitle">설정</div>
			<div id = "modalContent">
				<input type = "button" id = "Password" class = "btnS" value = "비밀번호 변경" onClick = "cngPassword()" />
				<input type = "button" id = "Theme" class = "btnS" value = "테마 변경" onClick = "cngTheme()" />
				<input type = "button" id = "Account" class = "btnS" value = "계정과목 변경" onClick = "cngAccount()" />
				<input type = "button" id = "Customer" class = "btnS" value = "거래처 변경" onClick = "cngCustomer()" />
			</div>
			<div id = "modalBottom">
				<input type = "button" id = "settingCancel" class = "btnC" value = "취소" onClick = "cancel()" />
			</div>
		</div>
	</div>
    <form name="serverForm"></form>
    <div id="footer">
        
    </div>
</body>
</html>