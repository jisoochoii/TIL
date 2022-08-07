<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>AccountBook :: Find Password</title>
<script>
	// 설화 - 페이지가 실행 될 떄 서버에서 받아온 true :: false에 따라서 비밀번호 알림창이 열렸다 닫힘.
	function getPassword() {
		// 서버에서 받아온 데이터는 이엘 양식으로 불러온다.
		if ("${disp}" != false) {
			// 기본값으로 NONE으로 해놓은 항목을 BLOCK으로 바꿔서 보여준다.
			document.getElementsByClassName("findOutInfo")[0].style.display = "block";
		}
	}

	// 설화 - 비밀번호 찾기 
	function findPassword() {
		// 서버로 보낼 폼을 불러와서 잡코드와 메소드방식을 지정 
		let form = document.getElementsByName("find-form")[0];
		form.action = "FindOutPassword";
		form.method = "post";

		// 서버에 넘길 데이터 입력한 내역을 불러옴 
		let mmCode = document.getElementsByName("MMCODE")[0];
		let mmName = document.getElementsByName("MMNAME")[0];
		let mmPhone = document.getElementsByName("MMPHONE")[0];

		// 불러온 데이터를 폼에 넣어
		form.appendChild(mmCode);
		form.appendChild(mmName);
		form.appendChild(mmPhone);

		// 폼을 서버로 보냄 
		form.submit();
	}

	// 설화 - 비밀번호 확인 후 로그인 페이지로 이동 
	function loginPage() {
		let form = document.getElementsByName("find-form")[0];
		form.action = "LoginPage";
		form.method = "post";
		form.submit();
	}
</script>
<style>
body {
	background-color: #EEEEEE;
	font-size: 16px;
	font-weight: normal;
}

.btn {
	/* 텍스트 그라데이션 */
	color: #000000;
	/* 테두리 그라데이션 */
	border: none;
	border: 0.2rem solid transparent;
	border-radius: 0.8rem;
	background-image: linear-gradient(#ffffff, #ffffff),
		linear-gradient(to right top, rgb(64, 201, 247), rgb(205, 73, 253));
	background-origin: border-box;
	background-clip: padding-box, border-box;
}

.container {
	display: flex;
	flex-direction: column;
	justify-content: space-around;
	width: 300px;
	height: 400px;
	text-align: center;
	transform: translate(50%, 50%);
	transform: translate(0%, 50%);
	margin: auto;
}

.findText {
	margin: 0 auto;
	padding: 10%;
}

.findBox {
	background: linear-gradient(to right top, rgb(64, 201, 247),
		rgb(205, 73, 253));
	color: #fff;
}

.findPassword {
	display: flex;
	flex-direction: column;
	justify-content: space-around;
	/* 텍스트 그라데이션 */
	background: linear-gradient(to right top, rgb(64, 201, 247),
		rgb(205, 73, 253));
	color: transparent;
	-webkit-background-clip: text;
}

.userCode, .userName, .userPassword, .userPhone, .find-btn {
	display: flex;
	justify-content: space-around;
	align-items: baseline;
	/* 텍스트 그라데이션 */
	background: linear-gradient(to right top, rgb(64, 201, 247),
		rgb(205, 73, 253));
	color: transparent;
	-webkit-background-clip: text;
}

.findOutInfo {
	display: none;
}

.fintOutText {
	align-items: center;
	flex-direction: column;
	background: linear-gradient(to right top, rgb(64, 201, 247),
		rgb(205, 73, 253));
	color: transparent;
	-webkit-background-clip: text;
}
</style>
</head>
<!-- 페이지가 실행될때마다 비밀번호 알림창을 열었다 닫기 위하여 onload -->
<body onload="getPassword()">
	<!-- Main -->
	<div class="container">
		<!-- Find Password -->
		<div class="findBox">
			<div class="findText">
				<h1>Find Password</h1>
			</div>
		</div>
		<!-- Password form -->
		<div class="findPassword">
			<form name="find-form">
				<div class="userCode">
					<h5>USERCODE</h5>
					<input type="text" name="MMCODE" placeholder="userCode" />
				</div>
				<div class="userName">
					<h5>USERNAME</h5>
					<input type="text" name="MMNAME" placeholder="userName" />
				</div>
				<div class="userPhone">
					<h5>USERPHONE</h5>
					<input type="text" name="MMPHONE" placeholder="userPhone" />
				</div>
				<div class="find-btn">
					<input type="button" value="FIND" class="btn"
						onClick="findPassword()">
				</div>
			</form>
		</div>
		<!-- Password Alert -->
		<div class="findOutInfo">
			<div class="fintOutText">
				<h4>
					<!-- 서버에서 받아온 데이터를 뿌려준다 -->
					비밀번호는 ${MMINFO[0].MMPASSWORD}입니다. <br>로그인 후 반드시 비밀번호를 변경해주세요.
				</h4>
				<input type="button" value="LOGIN" class="btn" onClick="loginPage()">
			</div>
		</div>
	</div>
</body>
</html>