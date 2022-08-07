<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>AccountBook :: Login</title>
<script src="/resources/js/access.js"></script>
<script>
	// 회원가입
	function init() { 
		//메세지 띄우기
		const message = "${message}"; 
		if(message != "") alert(message);
		
		//회원코드 불러오기
		let code = document.getElementsByName("MMCODE")[0];
		code.setAttribute("value", "${MMCODE}");
	}
	function join(){
		let name = document.getElementsByName("MMNAME")[0]
		let password = document.getElementsByName("MMPASSWORD")[0]
		let phone = document.getElementsByName("MMPHONE")[0]
		
		/*유효성 검사*/
		// 이름 2~5 글자
		if (isCharCheck(name.value, false)) {
			if (!isCharLengthCheck(name.value, 2, 5)) {
				alert("이름은 두글자에서 다섯글자 범위어야 합니다.");
				name.focus();
				return;
			}
		} else {
			alert("이름은 한글로 입력해야합니다.");
			name.focus();
			return;
		}
		
		// 비밀번호 유효성 검사 >> 영문자 대소문자 , 숫자 , 특수문자 >> 3개 이상의 타입을 사용하였는지 :: isCharCheck
		//					>> 전체 문자수는 6개 이상  ::isCharLengthCheck
		if (isCharCheck(password.value, true)) {
			if (!isCharLengthCheck(password.value, 6)) {
				alert("패스워드는 6자 이상이어야 합니다."); //max만 체크
				password.value = ""; //초기화
				password.focus();
				return;
			}
		} else {
			alert("영문 대소문자, 숫자, 특수문자 중 3종류 이상의 문자를 사용해 주세요.");
			password.value = "";
			password.focus();
			return;
		}
		
		// 핸드폰번호 유효성 검사 
		if (isNumberCheck(phone.value)){ // 숫자로만 구성되어있는지 확인
			if(!isCharLengthCheck(phone.value, 11)){ //11자리인지 확인
				alert("열한자리의 숫자를 입력하세요.")
				phone.focus();
				return;
			}
		}else{
			alert("숫자만 입력하실 수 있습니다.");
			phone.focus();
			return;
		}

		let form = document.getElementsByName("signUp-form")[0];
		form.action = "Join";
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
	border:none;
	border: 0.2rem solid transparent;
    border-radius: 0.8rem;
	background-image: linear-gradient(#ffffff, #ffffff), linear-gradient(to right top, rgb(64, 201, 247), rgb(205, 73, 253));
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

.signUpText {
	margin : 0 auto;
	padding: 10%;
}

.signUpBox {
	background: linear-gradient(to right top, rgb(64, 201, 247), rgb(205, 73, 253));
    color: #fff;
}

.signUp {
	display: flex;
	flex-direction: column;
    justify-content: space-around;
	/* 텍스트 그라데이션 */
	background: linear-gradient(to right top, rgb(64, 201, 247), rgb(205, 73, 253));
    color: transparent;
    -webkit-background-clip: text;
}

.userCode, .userName, .userPassword, .userPhone, .signUp-btn {
	display: flex;
	justify-content: space-around;
    align-items: baseline;
	/* 텍스트 그라데이션 */
	background: linear-gradient(to right top, rgb(64, 201, 247), rgb(205, 73, 253));
    color: transparent;
    -webkit-background-clip: text;
}

</style>
</head>
<body onLoad = "init()">
<!-- Main -->
	<div class="container">
		<!-- Join Page Move -->
		<div class="signUpBox">
			<div class="signUpText">
				<h1>Welcome to Join</h1>
			</div>
		</div>
		<!-- Login -->
		<div class="signUp">
			<form name="signUp-form">
				<div class="userCode">
					<h5>USERCODE</h5>
					<input type="text" name = "MMCODE" readonly=true />
				</div>
				<div class="userName">
					<h5>USERNAME</h5>
					<input type="text" name = "MMNAME" placeholder="userName" />
				</div>
                <div class="userPassword">
					<h5>PASSWORD</h5>
					<input type="password" name = "MMPASSWORD" placeholder="userPassword" />
				</div>
                <div class="userPhone">
					<h5>USERPHONE</h5>
					<input type="text" name = "MMPHONE" placeholder="userPhone" />
				</div>
				<div class="signUp-btn">
					<input type="button" value="Sign Up" class="btn"
						onClick="join()">
				</div>
			</form>
		</div>
	</div>
</body>
</html>