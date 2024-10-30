<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@ page import="java.util.Calendar" %>
<%
    // 현재 날짜와 시간을 얻기 위해 Calendar 객체를 생성합니다.
    Calendar calendar = Calendar.getInstance();
    int month = calendar.get(Calendar.MONTH) + 1; // Calendar의 MONTH는 0부터 시작하므로 1을 더해줍니다.
    int day = calendar.get(Calendar.DAY_OF_MONTH);

    // 각 날짜를 계산합니다.
    String date1 = month + "월 " + (day + 1) + "일";
    String date2 = month + "월 " + (day + 2) + "일";
    String date3 = month + "월 " + (day + 3) + "일";
    String date4 = month + "월 " + (day + 4) + "일";
    String date5 = month + "월 " + day + "일";
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>메인페이지</title>
<link href='<c:url value="/resources/css/home.css"/>' rel="stylesheet" type="text/css">
</head>
<body>
    <header>
        <div class="logo">
            <h1>SsumDay</h1>
        </div>
        <ul>
            <sec:authorize access="isAnonymous()">
                <li>
                    <a href="<c:url value='/loginPage'/>">로그인</a>
                </li>
                <li>
                    <a href="<c:url value='/join'/>" >회원가입</a>
                </li>          
            </sec:authorize>    
            <sec:authorize access="isAuthenticated()"> 
                <li>
                    <sec:authentication property="principal.member.user_no" var="sender_no"/>
                </li>
                <li>
                    <form method="post" action="/logout">
                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                        <input type="submit" value="로그아웃">
                    </form>
                </li>
            </sec:authorize>
        </ul>
    </header>

    <div class="search-container">
        <input type="text" id="city" name="city" placeholder="도시를 입력해주세요.">
        <button onclick="wbutton();">확인</button>
    </div>

    <section class="main-weather" style="margin-left: 100px;">
        <div class="text-container">
            <h1 id="curcity"></h1>
            <h1 class="date" id="date5" style="margin-top: -8px;"><%= date5 %></h1>
            <h3 class="time">현재 시간 : </h3>
            <h3 class="ctemp">현재 온도 : </h3>
            <h3 class="wind">풍속 : </h3>
            <h3 class="weather">날씨는 : </h3>
        </div>
        <div class="icon"></div>
    </section>

    <section class="weather-container">
        <div class="weather-card">
            <h2 class="date" id="date1"><%= date1 %></h2>
            <h3 class="tctemp">온도 : </h3>
            <h3 class="twind">풍속 : </h3>
            <h3 class="tweather">날씨는 : </h3>
            <div class="ticon icon"></div>
        </div>
        <div class="weather-card">
            <h2 class="date" id="date2"><%= date2 %></h2>
            <h3 class="actemp">온도 : </h3>
            <h3 class="awind">풍속 : </h3>
            <h3 class="aweather">날씨는 : </h3>
            <div class="aicon icon"></div>
        </div>
        <div class="weather-card">
            <h2 class="date" id="date3"><%= date3 %></h2>
            <h3 class="bctemp">온도 : </h3>
            <h3 class="bwind">풍속 : </h3>
            <h3 class="bweather">날씨는 : </h3>
            <div class="bicon icon"></div>
        </div>
        <div class="weather-card">
            <h2 class="date" id="date4"><%= date4 %></h2>
            <h3 class="cctemp">온도 : </h3>
            <h3 class="cwind">풍속 : </h3>
            <h3 class="cweather">날씨는 : </h3>
            <div class="cicon icon"></div>
        </div>
    </section>

    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"
        integrity="sha256-/JqT3SQfawRcv/BIHPThkBvs0OEvtFFmqPF/lYI/Cxo=" crossorigin="anonymous"></script>
    <script>
        function getWeatherIcon(mainWeather) {
            let iconUrl = '';
            switch (mainWeather) {
                case 'Clear':
                    iconUrl = '<%=request.getContextPath()%>/resources/image/sun.png';
                    break;
                case 'Rain':
                    iconUrl = '<%=request.getContextPath()%>/resources/image/rain.png';
                    break;
                case 'Snow':
                    iconUrl = '<%=request.getContextPath()%>/resources/image/snow.png';
                    break;
                case 'Clouds':
                    iconUrl = '<%=request.getContextPath()%>/resources/image/cloud.png';
                    break;
                case 'Mist':
                    iconUrl = '<%=request.getContextPath()%>/resources/image/mist.png';
                    break;
                case 'Thunderstorm':
                    iconUrl = '<%=request.getContextPath()%>/resources/image/Thunderstorm.png';
                    break;
                default:
                    iconUrl = '';
            }
            return iconUrl;
        }

        function wbutton() {
            const city = document.getElementById('city').value;

            // Google Translate API를 통해 한국어 도시명을 영어로 번역
            const apiKey = 'AIzaSyAR34uLtYkTKaCkjeVqGxC1cIyRc5zI2fk';
            const translateUrl = "https://translation.googleapis.com/language/translate/v2?key=" + apiKey;

            $.post(translateUrl, {
                q: city,
                source: 'ko',
                target: 'en',
                format: 'text'
            }, function (translationData) {
                const translatedCity = translationData.data.translations[0].translatedText;
                document.getElementById('curcity').innerHTML = city + ' 날씨는';

                // 번역된 도시 이름으로 OpenWeatherMap API 호출
                $.getJSON('https://api.openweathermap.org/data/2.5/weather?q=' + translatedCity + '&appid=952671dd9bc744f362850eea35cbafdb&units=metric', function (result) {
                    $('.ctemp').html('현재 온도 : ' + result.main.temp + '°C');
                    $('.wind').html('풍속 : ' + result.wind.speed + 'm/s');
                    $('.weather').html('날씨는 : ' + result.weather[0].main);

                    const iconUrl = getWeatherIcon(result.weather[0].main);
                    $('.icon').html('<img src="' + iconUrl + '" alt="' + result.weather[0].main + '" style=" width: 60%;">');

                    const ct = result.dt;
                    function convertTime(ct) {
                        const correctedTime = ct + 500;
                        const ot = new Date(correctedTime * 1000);
                        const hr = ot.getHours();
                        const m = ot.getMinutes();
                        const s = ot.getSeconds();
                        return hr + ':' + m + ':' + s;
                    }
                    const currentTime = convertTime(ct);
                    $('.time').html('현재 시간 : ' + currentTime);
                });

                $.getJSON('https://api.openweathermap.org/data/2.5/forecast?q=' + translatedCity + '&appid=952671dd9bc744f362850eea35cbafdb&units=metric', function (result) {
                    const oneindex = 8;
                    const onedata = result.list[oneindex];
                    $('.tctemp').html('온도: ' + onedata.main.temp + '°C');
                    $('.twind').html('풍속 : ' + onedata.wind.speed + 'm/s');
                    $('.tweather').html('날씨는 : ' + onedata.weather[0].main);
                    const ticonUrl = getWeatherIcon(onedata.weather[0].main);
                    $('.ticon').html('<img src="' + ticonUrl + '" alt="' + onedata.weather[0].main + '" style=" width: 60%;">');

                    const twoindex = 16;
                    const twodata = result.list[twoindex];
                    $('.actemp').html('온도: ' + twodata.main.temp + '°C');
                    $('.awind').html('풍속 : ' + twodata.wind.speed + 'm/s');
                    $('.aweather').html('날씨는 : ' + twodata.weather[0].main);
                    const aiconUrl = getWeatherIcon(twodata.weather[0].main);
                    $('.aicon').html('<img src="' + aiconUrl + '" alt="' + twodata.weather[0].main + '"style=" width: 60%;">');

                    const threeindex = 24;
                    const threedata = result.list[threeindex];
                    $('.bctemp').html('온도: ' + threedata.main.temp + '°C');
                    $('.bwind').html('풍속 : ' + threedata.wind.speed + 'm/s');
                    $('.bweather').html('날씨는 : ' + threedata.weather[0].main);
                    const biconUrl = getWeatherIcon(threedata.weather[0].main);
                    $('.bicon').html('<img src="' + biconUrl + '" alt="' + threedata.weather[0].main + '"style=" width: 60%;">');

                    const fourindex = 32;
                    const fourdata = result.list[fourindex];
                    $('.cctemp').html('온도: ' + fourdata.main.temp + '°C');
                    $('.cwind').html('풍속 : ' + fourdata.wind.speed + 'm/s');
                    $('.cweather').html('날씨는 : ' + fourdata.weather[0].main);
                    const ciconUrl = getWeatherIcon(fourdata.weather[0].main);
                    $('.cicon').html('<img src="' + ciconUrl + '" alt="' + fourdata.weather[0].main + '"style=" width: 60%;">');
                });
            });
        }
    </script>
</body>
</html>
