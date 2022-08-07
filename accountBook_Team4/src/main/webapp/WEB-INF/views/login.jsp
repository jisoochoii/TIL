<!-- <%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%> -->
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>AccountBook :: Login</title>
<script src="/resources/js/access.js"></script>
<script>
function init(){
	getAjaxJson("https://api.ipify.org","format=json","setPublicIp");

	//메세지 띄우기
	const message = "${message}"; 
	if(message != "") alert(message);
}

	// 로그인
	function login() {
		let publicIp=createInput("hidden","AHPUBLICIP","","","","");
		publicIp.setAttribute("value",jsonData.ip);

		const pmbCode = document.getElementsByName("MMCode")[0];
		const pmbPassword = document.getElementsByName("MMPassword")[0];
		
		let form = document.getElementsByName("signIn-form")[0];
			
		form.action = "Access";
		form.method = "post";
		 const dataDiv = document.getElementById("canvas");
		form.appendChild(publicIp);
		
		form.appendChild(dataDiv); 
		form.submit();
	}

	// 회원가입 폼 이동 
	function join_form() {
		let form = document.getElementsByName("signIn-form")[0];
		form.action = "JoinForm";
		form.method = "post";
		form.submit();
	}

	// 비밀번호 찾기
	function password() {
		let form = document.getElementsByName("signIn-form")[0];
		form.action = "FindPassword";
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
	border: none;
	border-radius: 0.8rem;
	width: auto;
	height: auto;
	/* 텍스트 그라데이션 */
	background-color: #ffffff;
	/* background-color: linear-gradient(to right top, rgb(64, 201, 247), rgb(205, 73, 253));
    color: transparent;
    -webkit-background-clip: text; */
	/* 테두리 그라데이션 */
	/* border: 0.2rem solid transparent;
    border-radius: 0.8rem;
	background-image: linear-gradient(#ffffff, #ffffff), linear-gradient(to right top, rgb(64, 201, 247), rgb(205, 73, 253));
	background-origin: border-box;
	background-clip: content-box, border-box; */
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

.signUpText {
	margin-bottom: 5%;
}

.signUpBox {
	background: linear-gradient(90deg, #cd49fd 0%, #40c9f7 100%);
	color: #fff;
}

.signIn {
	/* 텍스트 그라데이션 */
	background: linear-gradient(to right top, rgb(64, 201, 247),
		rgb(205, 73, 253));
	color: transparent;
	-webkit-background-clip: text;
}

.userCode, .userPassword, .order, .signIn-btn {
	display: flex;
	align-items: baseline;
	justify-content: space-around;
	/* 텍스트 그라데이션 */
	background: linear-gradient(to right top, rgb(64, 201, 247),
		rgb(205, 73, 253));
	color: transparent;
	-webkit-background-clip: text;
}
</style>
</head>
<body onload="init()">
	<!-- Main -->
	<div class="container">
		<!-- Join Page Move -->
		<div class="signUpBox">
			<div class="signUpText">
				<h1>Welcome to login</h1>
				<p>Don't have an account?</p>
				<input type="button" value="Sign Up" class="btn"
					onClick="join_form()" />
			</div>
		</div>
		<!-- Login -->
		<div class="signIn">
			<div class="signInTitle">
				<h3>Sign In</h3>
			</div>
			<form name="signIn-form">
				<div id="canvas" class="canvas">
					<div class="userCode">
						<h5>USERCODE</h5>
						<input type="text" name="MMCODE" placeholder="userCode" />
					</div>
					<div class="userPassword">
						<h5>PASSWORD</h5>
						<input type="password" name="MMPASSWORD"
							placeholder="userPassword" />
					</div>
					<div class="signIn-btn">
						<input type="button" value="Sign In" class="btn"
							onClick="window.login()" />
					</div>
				</div>
			</form>
		</div>
		<!-- eee -->
		<div class="order">
			<div class="RememberMe">
				<h5>
					<input type="checkbox" checked /> Remember Me
				</h5>
			</div>
			<div class="ForgotPassword">
				<h5 onClick="password()">Forgot Password</h5>
			</div>
		</div>
	</div>
</body>
</html>