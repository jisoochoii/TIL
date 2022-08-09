function createInputDiv(id, text, value, className) {
	let div = document.createElement("div");
	if(id != null) div.setAttribute("id", id);
	if(className != null) div.setAttribute("class", className);
	if(value != null) div.setAttribute("value", value);
	if(text != null) div.innerHTML = text;
	div.onkeyup=function (e) {
		if(e.key === "Enter") {
			updCustomer(this);
		}
	}
	
	return div;
}

function createDiv(id, text, value, className) {
	let div = document.createElement("div");
	if(id != null) div.setAttribute("id", id);
	if(className != null) div.setAttribute("class", className);
	if(value != null) div.setAttribute("value", value);
	if(text != null) div.innerHTML = text;
	
	return div;
}

/* Ajax :: GET */
function getAjaxJson(jobCode, clientData, fn) {
	const ajax = new XMLHttpRequest();
	const action = (clientData!="")?(jobCode + "?" + clientData):jobCode;
	
	ajax.onreadystatechange = function() {
		if(ajax.readyState == 4 && ajax.status == 200) { //4:데이터가 넘어옴
			window[fn](ajax.responseText); //응답 데이터를 처리할 메소드 호출
		}
	};

	ajax.open("get", action);
	ajax.send();
}
/* Ajax :: POST */
function postAjaxJson(jobCode, clientData, fn) {
	const ajax = new XMLHttpRequest();

	ajax.onreadystatechange = function() {
		if(ajax.readyState == 4 && ajax.status == 200) { //4:데이터가 넘어옴
			window[fn](ajax.responseText); //응답 데이터
		}
	};

	//post방식은 form이 필요, 해당 방식은 form이 없으므로 urlencoded방식으로 데이터 전송, 
	ajax.open("post", jobCode);
	ajax.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
	ajax.send(clientData);
}
/* input박스에 천단위 컴마 숫자 펑션 */
function inputNumberFormat(obj) {
    obj.value = comma(uncomma(obj.value));
}
function comma(str) {
    str = String(str);
    return str.replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,');
}

function uncomma(str) {
    str = String(str);
    return str.replace(/[^\d]+/g, '');
}
