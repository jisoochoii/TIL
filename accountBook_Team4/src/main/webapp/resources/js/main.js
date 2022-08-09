// 테마변경을 위한 전역변수
let HBCOLOR="";
let HFCOLOR="";
let CBCOLOR="";
let CFCOLOR="";

/***********************/
// 토글스위치 윈도우 상속 ON -- DB에 보내서 컬러값을 저장해서 가져와라...
function cngWindow() {
	let header = document.getElementById("header");
	let container = document.getElementById("container");

	let isCheck = document.getElementById("windowSystem");
	let windowTheme = window.matchMedia("(prefers-color-scheme: dark)").matches;
	alert(windowTheme);

	let color = false;

	if (!isCheck.checked) {
		alert("isCheck-해제");
		//		window.matchMedia("(prefers-color-scheme: dark)").matches? "dark" : "light”
		document.head.insertAdjacentHTML('beforeend', '<link rel="stylesheet" href="/resources/css/light.css" media="(prefers-color-scheme: light)">');

		color = false;
	} else if (isCheck.checked) {
		alert("isCheck-설정");
		if (windowTheme == true) {
			alert("다크모드");
			document.head.insertAdjacentHTML('beforeend', '<link rel="stylesheet" href="/resources/css/dark.css" media="(prefers-color-scheme: dark)">');
		} else if (windowTheme == false) {
			alert("라이트모드");
			document.head.insertAdjacentHTML('beforeend', '<link rel="stylesheet" href="/resources/css/light.css" media="(prefers-color-scheme: light)">');
		}

		color = true;
	}
	webTheme(color);
}

function webTheme(isCheck) {

	if (isCheck) {
		alert("나는야 트루! 바로 시스템 설정을 따라가지~~~");
	} else if (!isCheck) {
		alert("나는야 펄스! 그냥 기본값을 따라가지~~~");
	}
}

// 토글스위치 다크모드 ON 
function cngDark() {
	let isCheck = document.getElementById("darkSystem");
	if (isCheck.checked) {
		alert("isCheck-설정");
	} else if (!isCheck.checked) {
		alert("isCheck-해제");
	}
}

// 변경하고 싶은 테마 클릭시 변경
function cngColor(color) {
	switch (color) {
		case 'pink':
			alert("핑크");
			HBCOLOR = "#333D79";
			HFCOLOR = "#FBEAEB";
			CBCOLOR = "#FBEAEB";
			CFCOLOR = "#333D79";
			break;
		case 'yellow':
			alert("노랑");
			HBCOLOR = "#F96167";
			HFCOLOR = "#FCE77D";
			CBCOLOR = "#FCE77D";
			CFCOLOR = "#F96167";
			break;
		case 'blue':
			alert("블루");
			HBCOLOR = "#8AAAE5";
			HFCOLOR = "#FCF6F5";
			CBCOLOR = "#FCF6F5";
			CFCOLOR = "#8AAAE5";
			break;
		case 'purple':
			alert("보라");
			HBCOLOR = "#9000FF";
			HFCOLOR = "#FFE8F5";
			CBCOLOR = "#FFE8F5";
			CFCOLOR = "#9000FF";
			break;
		case 'grean':
			alert("그린");
			HBCOLOR = "#2BAE66";
			HFCOLOR = "#FCF6F5";
			CBCOLOR = "#FCF6F5";
			CFCOLOR = "#2BAE66";
			break;
		default:
	}
	
	// 사용자가 지정한 테마색상값을 넘기기 위해 이동
	onTheme();
}

// 컬러 테마 색상코드를 서버에 전송하여 저장함.
function onTheme() {
	let clientData = "HBCOLOR="+HBCOLOR+"&HFCOLOR="+HFCOLOR;
		clientData+= "&CBCOLOR="+CBCOLOR+"&CFCOLOR="+CFCOLOR;

	console.log("clientData : " + clientData);

	postAjaxJson("CngTheme", clientData, "updTheme");
}

// 서버에서 색상코드 데이터를 다시 리턴 받아서 테마 적용.
function updTheme(ajaxData) {
	let jsonData = JSON.parse(ajaxData);

	let header = document.getElementById("header");
	let container = document.getElementById("container");
	
	header.style.background = jsonData.hbcolor;
	header.style.color = jsonData.hfcolor;
	container.style.background = jsonData.cbcolor;
	container.style.color = jsonData.cfcolor;
   
}

/*********************        AJAX        **********************/

/* AJAX GET */
function getAjaxJson(jobCode, clientData, fn) { //url?key=value
	const ajax = new XMLHttpRequest();
	const action = (clientData != "") ? (jobCode + "?" + clientData) : jobCode;

	ajax.onreadystatechange = function() {
		if (ajax.readyState == 4 && ajax.status == 200) {
			window[fn](ajax.responseText); //function으로 인식하려면 window사용
		}
	};

	ajax.open("get", action);
	ajax.send();
}

/* AJAX POST */
function postAjaxJson(jobCode, clientData, fn) { //formdata
	const ajax = new XMLHttpRequest();
	ajax.onreadystatechange = function() {
		if (ajax.readyState == 4 && ajax.status == 200) {
			window[fn](ajax.responseText); //function으로 인식하려면 window사용
		}
	}

	ajax.open("post", jobCode);
	// key=value이런식으로 보내려면 서버에 알려줘야함 원래 post는 form만 인식하기때문에 urlencoded방식사용
	ajax.setRequestHeader("Content-Type", "application/x-www.form.urlencoded");
	ajax.send(clientData);
}
/* 폼에 원하는 정보를 어펜드차일드 해주기 위한 메서드 */
function createHidden(objName, value){
	let input = document.createElement("input");
	input.setAttribute("type", "hidden");
	input.setAttribute("name", objName);
	input.setAttribute("value", value);
	
	return input;
}