<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<%@ include file="./cmm/resources.jsp" %>
	<script src="<%=request.getContextPath() %>/resources/js/d3.min.js"></script>
	<script>
		$(document).ready(function(){
			var q = "INSERT INTO `cmmn_code` VALUES ('CAR_COMP','%{code}','%{codeName}','%{codeName}','Y',%{sort},NULL,NULL,NULL,NULL,'CAR');"
			$("#company-list").find("option").each(function(i){
				var newQ = Common.matchedReplace( q, {
					code:this.value
					,codeName:this.textContent
					,sort:i-2
				});
				console.log( newQ );
			});
		});
	</script>
	<style type="text/css">
		
	</style>
</head>
<body>
<select name="companyList" class="filterable-select"  id="company-list" data-native-menu="false">
					<option>제조사</option>
					<option value="" >전체</option>
					<option value="0" >현대자동차</option>
					<option value="1" >기아자동차</option>
					<option value="2" >쉐보레</option>
					<option value="3" >르노삼성</option>
					<option value="4" >쌍용자동차</option>
					<option value="5" >제네시스</option>
					<option value="6" >벤츠</option>
					<option value="7" >BMW</option>
					<option value="8" >아우디</option>
					<option value="9" >폭스바겐</option>
					<option value="10" >포드</option>
					<option value="11" >랜드로버</option>
					<option value="12" >렉서스</option>
					<option value="13" >토요타</option>
					<option value="14" >미니</option>
					<option value="15" >혼다</option>
					<option value="16" >크라이슬러</option>
					<option value="17" >닛산</option>
					<option value="18" >볼보</option>
					<option value="19" >재규어</option>
					<option value="20" >푸조</option>
					<option value="21" >인피니티</option>
					<option value="22" >포르쉐</option>
					<option value="23" >캐딜락</option>
					<option value="24" >시트로엥</option>
					<option value="25" >피아트</option>
					<option value="26" >벤틀리</option>
					<option value="27" >롤스로이스</option>
					<option value="28" >람보르기니</option>
					<option value="29" >페라리</option>
					<option value="30" >닷지</option>
					<option value="31" >로터스</option>
					<option value="32" >르노</option>
					<option value="33" >링컨</option>
					<option value="34" >마이바흐</option>
					<option value="35" >마쯔다</option>
					<option value="36" >머큐리</option>
					<option value="37" >미쓰비시</option>
					<option value="38" >뷰익</option>
					<option value="39" >사브</option>
					<option value="40" >사이언</option>
					<option value="41" >새턴</option>
					<option value="42" >스마트</option>
					<option value="43" >스바루</option>
					<option value="44" >스즈키</option>
					<option value="45" >스코다</option>
					<option value="46" >알파로메오</option>
					<option value="47" >애스턴마틴</option>
					<option value="48" >어큐라</option>
					<option value="49" >지프</option>
					<option value="50" >코닉세그</option>
					<option value="51" >파가니</option>
					<option value="52" >폰티악</option>
					<option value="53" >허머</option>
					<option value="54" >홀덴</option>
					<option value="55" >마세라티</option>
					<option value="56" >GMC</option>
					<option value="57" >Great Wall</option>
					<option value="58" >RUF</option>
					<option value="59" >W모터스</option>
					<option value="60" >국제차량제작</option>
					<option value="61" >다이하쓰</option>
					<option value="62" >다치아</option>
					<option value="63" >돈커부트</option>
					<option value="64" >드로리언</option>
					<option value="65" >란치아</option>
					<option value="66" >마러시아</option>
					<option value="67" >마잔티</option>
					<option value="68" >마힌드라</option>
					<option value="69" >맥라렌</option>
					<option value="70" >모건</option>
					<option value="71" >미아일렉트릭</option>
					<option value="72" >미쯔오카</option>
					<option value="73" >복스홀</option>
					<option value="74" >부가티</option>
					<option value="75" >북기은상</option>
					<option value="76" >살린</option>
					<option value="77" >세아트</option>
					<option value="78" >쉘비</option>
					<option value="79" >쉘비슈퍼카</option>
					<option value="80" >스파이커</option>
					<option value="81" >스피라</option>
					<option value="82" >아바쓰</option>
					<option value="83" >아브토바즈</option>
					<option value="84" >알피나</option>
					<option value="85" >에쿠스 오토모티브</option>
					<option value="86" >엘레멘탈</option>
					<option value="87" >오펠</option>
					<option value="88" >이스즈</option>
					<option value="89" >장링</option>
					<option value="90" >젠보</option>
					<option value="91" >카르마 오토모티브</option>
					<option value="92" >칼슨</option>
					<option value="93" >케이터햄</option>
					<option value="94" >쿠오로스</option>
					<option value="95" >타타</option>
					<option value="96" >테슬라</option>
					<option value="97" >포톤</option>
					<option value="98" >한국지엠</option>
					<option value="99" >헤네시</option>
				</select>
</body>
</html>