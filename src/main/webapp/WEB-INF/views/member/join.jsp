<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원가입</title>
<link href="<c:url value='/resources/css/member/join.css' />" rel="stylesheet" type="text/css">
</head>
<body>
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>    
    <section>
        <div id="section_wrap">
            <div class="word">
                <h3>회원가입</h3>
            </div><br>
            <div class="create_account_form">
                <form id="memberAddFrm">
                    <input type="text" name="user_id" placeholder="아이디"> <br>
                    <input type="password" name="user_pw" placeholder="비밀번호"> <br>
                    <input type="password" name="user_pw_check" placeholder="비밀번호 확인"> <br>
                    <input type="text" name="user_name" placeholder="이름"> <br>
                    <input type="text" id="sample6_postcode" name="user_postcode" placeholder="우편번호">
                    <input type="button" onclick="sample6_execDaumPostcode()" value="우편번호 찾기"><br>
                    <input type="text" id="sample6_address" name="user_address" placeholder="주소"><br>
                    <input type="text" id="sample6_detailAddress" name="user_detailAddress" placeholder="상세주소">
                    <input type="text" id="sample6_extraAddress" name="user_extraAddress" placeholder="참고항목">
            <div class="login">
                <input type="submit" value="회원가입">
                <a href="<c:url value='/' />">취소</a>
            </div>
            </form>
            </div>
        </div>
    </section>
    <script>
     function sample6_execDaumPostcode() {
            new daum.Postcode({
                oncomplete: function(data) {
                    var addr = ''; 
                    var extraAddr = ''; 

                    if (data.userSelectedType === 'R') { 
                        addr = data.roadAddress;
                    } else { 
                        addr = data.jibunAddress;
                    }

                    if(data.userSelectedType === 'R'){
                        if(data.bname !== '' && /[동|로|가]$/g.test(data.bname)){
                            extraAddr += data.bname;
                        }
                        if(data.buildingName !== '' && data.apartment === 'Y'){
                            extraAddr += (extraAddr !== '' ? ', ' + data.buildingName : data.buildingName);
                        }
                        if(extraAddr !== ''){
                            extraAddr = ' (' + extraAddr + ')';
                        }
                        document.getElementById("sample6_extraAddress").value = extraAddr;
                    
                    } else {
                        document.getElementById("sample6_extraAddress").value = '';
                    }

                    document.getElementById('sample6_postcode').value = data.zonecode;
                    document.getElementById("sample6_address").value = addr;
                    document.getElementById("sample6_detailAddress").focus();
                }
            }).open();
        }
    
        const form = document.getElementById('memberAddFrm');
        
        form.addEventListener('submit',(e)=>{
            e.preventDefault();
            
            let vali_check = false;
            let vali_text = "";
            if(form.user_id.value == ""){
                vali_text += '아이디를 입력하세요.';
                form.user_id.focus();
            }else if(form.user_pw.value == ""){
                vali_text += '비밀번호를 입력하세요';
                form.user_pw.focus();
            }else if(form.user_pw_check.value == ""){
                vali_text += '비밀번호 확인을 입력하세요';
                form.user_pw_check.focus();
            }else if(form.user_name.value == ""){
                vali_text += '이름을 입력하세요.';
                form.user_name.value = '';
            }else if(form.user_address.value == ""){
                vali_text += '주소를 입력하세요.';
                form.sample6_address.focus();
            }else{
                vali_check = true;
            }
            
            if(vali_check == false){
                alert(vali_text);
            }else{
                let object = {};
                const payload = new FormData(form);
                payload.forEach(function(value,key){
                    object[key] = value;
                });
                const jsonData = JSON.stringify(object);
                fetch('<%=request.getContextPath()%>/join',{
                    method : 'POST',
                    headers : {
                        "Content-Type" : "application/json;charset=utf-8",
                        "Accept" : "application/json",
                        "X-CSRF-TOKEN" : "${_csrf.token}"
                    },
                    body : jsonData
                })
                .then(response => response.json())
                .then(data =>{
                    alert(data.res_msg);
                    if(data.res_code == '200'){
                        location.href="<%=request.getContextPath()%>/loginPage";
                    }
                })
            }
        })
    </script>    
</body>
</html>
