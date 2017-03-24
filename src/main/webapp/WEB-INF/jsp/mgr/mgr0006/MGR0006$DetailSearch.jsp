<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<style>
	#detailSearch .ui-panel-inner{padding:0;}
	p.company{font-size:0.8em; margin:0; padding:0;}
	.companyList { max-height:200px;overflow-y:scroll;border:1px solid #ddd;text-align: center;}
	.ui-block-a
	,.ui-block-b
	,.ui-block-c
	,.ui-block-d
	,.ui-block-e
	, .companyList .ui-btn { padding:0; margin:0;}
	.grid-block{ 
		min-height:85px;
		border-right: 1px solid #ddd;
    	border-bottom: 1px solid #ddd;
	}
	.ui-block-e.grid-block { border-right:0;}
	.selected{
		background: #044363 !important;
	    color: #fff !important;
	}
	.car-type ,.car-fure  {}
	.car-fure {}
	.title{border-top:0;border-bottom:0;}
	.cont{ border-top:0; }
	#detailSearch .ui-corner-all{
		-webkit-border-top-left-radius: 0;
	    border-top-left-radius: 0;
	    -webkit-border-top-right-radius: 0;
	    border-top-right-radius: 0;
		-webkit-border-bottom-left-radius: 0;
	    border-bottom-left-radius: 0;
	    -webkit-border-bottom-right-radius: 0;
	    border-bottom-right-radius: 0;
	}
	.ui-block-a label,  .ui-block-a .ui-bar{ border-right:0;}
	.ui-selectmenu-list.ui-listview{ margin-top:0;}
	.ui-selectmenu .ui-input-clear{ padding:0;}
	.detailSearch .ui-select {margin-top:0; margin-bottom:0;}
</style>

<!-- 상세조회옵션 판넬 -->
	<div id="detailSearch" data-role='panel' data-position='right' data-display='overlay' data-position-fixed="true" >
<!-- 			<div class='ui-bar ui-bar-c'>상세조회옵션</div> -->
			<div class='ui-bar ui-bar-c'>제조사</div>
			<div class='detailSearch'>
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
			</div>
			<!-- <div class='ui-bar ui-bar-a'>제조사</div>
			<div class='companyList'>
				<div class="ui-grid-d">
					<div class='ui-block-a grid-block'>
							<img class="embImg" src="http://static.naver.net/m/auto/img/emblem/mnfco_16.png" data-src="http://static.naver.net/m/auto/img/emblem/mnfco_16.png" width="35px" height="35px" alt="현대자동차">
							<p class="company">현대자동차</p>
					</div>
					<div class='ui-block-b grid-block'>
						
							<img class="embImg" src="http://static.naver.net/m/auto/img/emblem/mnfco_12.png" data-src="http://static.naver.net/m/auto/img/emblem/mnfco_12.png" width="35px" height="35px" alt="기아자동차">
							<p class="company">기아자동차</p>
						
					</div>
					<div class='ui-block-c grid-block' >
							<img class="embImg" src="http://static.naver.net/m/auto/img/emblem/mnfco_48.png" data-src="http://static.naver.net/m/auto/img/emblem/mnfco_48.png" width="35px" height="35px" alt="쉐보레">
							<p class="company">쉐보레</p>
						
					</div>
					<div class='ui-block-d grid-block'>
							<img class="embImg" src="http://static.naver.net/m/auto/img/emblem/mnfco_15.png" data-src="http://static.naver.net/m/auto/img/emblem/mnfco_15.png" width="35px" height="35px" alt="르노삼성">
							<p class="company">르노삼성</p>
						
					</div>
					<div class='ui-block-e grid-block'>
						
							<img class="embImg" src="http://static.naver.net/m/auto/img/emblem/mnfco_13.png" data-src="http://static.naver.net/m/auto/img/emblem/mnfco_13.png" width="35px" height="35px" alt="쌍용자동차">
							<p class="company">쌍용자동차</p>
						
					</div>
				</div>
				<div class="ui-grid-d">
					<div class='ui-block-a grid-block'>
						
							<img class="embImg" src="http://static.naver.net/m/auto/img/emblem/mnfco_61321.png" data-src="http://static.naver.net/m/auto/img/emblem/mnfco_61321.png" width="35px" height="35px" alt="제네시스">
							<p class="company">제네시스</p>
						
					</div>
					<div class='ui-block-b grid-block'>
						
							<img class="embImg" src="http://static.naver.net/m/auto/img/emblem/mnfco_21.png" data-src="http://static.naver.net/m/auto/img/emblem/mnfco_21.png" width="35px" height="35px" alt="벤츠">
							<p class="company">벤츠</p>
						
					</div>
					<div class='ui-block-c grid-block'>
						
							<img class="embImg" src="http://static.naver.net/m/auto/img/emblem/mnfco_23.png" data-src="http://static.naver.net/m/auto/img/emblem/mnfco_23.png" width="35px" height="35px" alt="BMW">
							<p class="company">BMW</p>
						
					</div>
					<div class='ui-block-d grid-block'>
						
							<img class="embImg" src="http://static.naver.net/m/auto/img/emblem/mnfco_18.png" data-src="http://static.naver.net/m/auto/img/emblem/mnfco_18.png" width="35px" height="35px" alt="아우디">
							<p class="company">아우디</p>
						
					</div>
					<div class='ui-block-e grid-block'>
						
							<img class="embImg" src="http://static.naver.net/m/auto/img/emblem/mnfco_20.png" data-src="http://static.naver.net/m/auto/img/emblem/mnfco_20.png" width="35px" height="35px" alt="폭스바겐">
							<p class="company">폭스바겐</p>
						
					</div>
				</div>
				<div class="ui-grid-d">
					<div class='ui-block-a grid-block'>
						
							<img class="embImg" src="http://static.naver.net/m/auto/img/emblem/mnfco_30.png" data-src="http://static.naver.net/m/auto/img/emblem/mnfco_30.png" width="35px" height="35px" alt="포드">
							<p class="company">포드</p>
						
					</div>
					<div class='ui-block-b grid-block'>
						
							<img class="embImg" src="http://static.naver.net/m/auto/img/emblem/mnfco_39.png" data-src="http://static.naver.net/m/auto/img/emblem/mnfco_39.png" width="35px" height="35px" alt="랜드로버">
							<p class="company">랜드로버</p>
						
					</div>
					<div class='ui-block-c grid-block'>
						
							<img class="embImg" src="http://static.naver.net/m/auto/img/emblem/mnfco_22.png" data-src="http://static.naver.net/m/auto/img/emblem/mnfco_22.png" width="35px" height="35px" alt="렉서스">
							<p class="company">렉서스</p>
						
					</div>
					<div class='ui-block-d grid-block'>
						
							<img class="embImg" src="http://static.naver.net/m/auto/img/emblem/mnfco_41.png" data-src="http://static.naver.net/m/auto/img/emblem/mnfco_41.png" width="35px" height="35px" alt="토요타">
							<p class="company">토요타</p>
						
					</div>
					<div class='ui-block-e grid-block'>
						
							<img class="embImg" src="http://static.naver.net/m/auto/img/emblem/mnfco_6435.png" data-src="http://static.naver.net/m/auto/img/emblem/mnfco_6435.png" width="35px" height="35px" alt="미니">
							<p class="company">미니</p>
						
					</div>
				</div>
				<div class="ui-grid-d">
					<div class='ui-block-a grid-block'>
						
							<img class="embImg" src="http://static.naver.net/m/auto/img/emblem/mnfco_31.png" data-src="http://static.naver.net/m/auto/img/emblem/mnfco_31.png" width="35px" height="35px" alt="혼다">
							<p class="company">혼다</p>
						
					</div>
					<div class='ui-block-b grid-block'>
						
							<img class="embImg" src="http://static.naver.net/m/auto/img/emblem/mnfco_26.png" data-src="http://static.naver.net/m/auto/img/emblem/mnfco_26.png" width="35px" height="35px" alt="크라이슬러">
							<p class="company">크라이슬러</p>
						
					</div>
					<div class='ui-block-c grid-block'>
						
							<img class="embImg" src="http://static.naver.net/m/auto/img/emblem/mnfco_33.png" data-src="http://static.naver.net/m/auto/img/emblem/mnfco_33.png" width="35px" height="35px" alt="닛산">
							<p class="company">닛산</p>
						
					</div>
					<div class='ui-block-d grid-block'>
						
							<img class="embImg" src="http://static.naver.net/m/auto/img/emblem/mnfco_24.png" data-src="http://static.naver.net/m/auto/img/emblem/mnfco_24.png" width="35px" height="35px" alt="볼보">
							<p class="company">볼보</p>
						
					</div>
					<div class='ui-block-e grid-block'>
						
							<img class="embImg" src="http://static.naver.net/m/auto/img/emblem/mnfco_25.png" data-src="http://static.naver.net/m/auto/img/emblem/mnfco_25.png" width="35px" height="35px" alt="재규어">
							<p class="company">재규어</p>
						
					</div>
				</div>
				<div class="ui-grid-d">
					<div class='ui-block-a grid-block'>
						
							<img class="embImg" src="http://static.naver.net/m/auto/img/emblem/mnfco_28.png" data-src="http://static.naver.net/m/auto/img/emblem/mnfco_28.png" width="35px" height="35px" alt="푸조">
							<p class="company">푸조</p>
						
					</div>
					<div class='ui-block-b grid-block'>
						
							<img class="embImg" src="http://static.naver.net/m/auto/img/emblem/mnfco_34.png" data-src="http://static.naver.net/m/auto/img/emblem/mnfco_34.png" width="35px" height="35px" alt="인피니티">
							<p class="company">인피니티</p>
						
					</div>
					<div class='ui-block-c grid-block'>
						
							<img class="embImg" src="http://static.naver.net/m/auto/img/emblem/mnfco_3905.png" data-src="http://static.naver.net/m/auto/img/emblem/mnfco_3905.png" width="35px" height="35px" alt="포르쉐">
							<p class="company">포르쉐</p>
						
					</div>
					<div class='ui-block-d grid-block'>
						
							<img class="embImg" src="http://static.naver.net/m/auto/img/emblem/mnfco_19.png" data-src="http://static.naver.net/m/auto/img/emblem/mnfco_19.png" width="35px" height="35px" alt="캐딜락">
							<p class="company">캐딜락</p>
						
					</div>
					<div class='ui-block-e grid-block'>
						
							<img class="embImg" src="http://static.naver.net/m/auto/img/emblem/mnfco_3848.png" data-src="http://static.naver.net/m/auto/img/emblem/mnfco_3848.png" width="35px" height="35px" alt="시트로엥">
							<p class="company">시트로엥</p>
						
					</div>
				</div>
				<div class="ui-grid-d">
					<div class='ui-block-a grid-block'>
						
							<img class="embImg" src="http://static.naver.net/m/auto/img/emblem/mnfco_4029.png" data-src="http://static.naver.net/m/auto/img/emblem/mnfco_4029.png" width="35px" height="35px" alt="피아트">
							<p class="company">피아트</p>
						
					</div>
					<div class='ui-block-b grid-block'>
						
							<img class="embImg" src="http://static.naver.net/m/auto/img/emblem/mnfco_4129.png" data-src="http://static.naver.net/m/auto/img/emblem/mnfco_4129.png" width="35px" height="35px" alt="벤틀리">
							<p class="company">벤틀리</p>
						
					</div>
					<div class='ui-block-c grid-block'>
						
							<img class="embImg" src="http://static.naver.net/m/auto/img/emblem/mnfco_3824.png" data-src="http://static.naver.net/m/auto/img/emblem/mnfco_3824.png" width="35px" height="35px" alt="롤스로이스">
							<p class="company">롤스로이스</p>
						
					</div>
					<div class='ui-block-d grid-block'>
						
							<img class="embImg" src="http://static.naver.net/m/auto/img/emblem/mnfco_3814.png" data-src="http://static.naver.net/m/auto/img/emblem/mnfco_3814.png" width="35px" height="35px" alt="람보르기니">
							<p class="company">람보르기니</p>
						
					</div>
					<div class='ui-block-e grid-block'>
						
							<img class="embImg" src="http://static.naver.net/m/auto/img/emblem/mnfco_27.png" data-src="http://static.naver.net/m/auto/img/emblem/mnfco_27.png" width="35px" height="35px" alt="페라리">
							<p class="company">페라리</p>
						
					</div>
				</div>
				<div class="ui-grid-d">
					<div class='ui-block-a grid-block'>
						
							<img class="embImg" src="http://static.naver.net/m/auto/img/emblem/mnfco_4188.png" data-src="http://static.naver.net/m/auto/img/emblem/mnfco_4188.png" width="35px" height="35px" alt="닷지">
							<p class="company">닷지</p>
						
					</div>
					<div class='ui-block-b grid-block'>
						
							<img class="embImg" src="http://static.naver.net/m/auto/img/emblem/mnfco_4040.png" data-src="http://static.naver.net/m/auto/img/emblem/mnfco_4040.png" width="35px" height="35px" alt="로터스">
							<p class="company">로터스</p>
						
					</div>
					<div class='ui-block-c grid-block'>
						
							<img class="embImg" src="http://static.naver.net/m/auto/img/emblem/mnfco_3847.png" data-src="http://static.naver.net/m/auto/img/emblem/mnfco_3847.png" width="35px" height="35px" alt="르노">
							<p class="company">르노</p>
						
					</div>
					<div class='ui-block-d grid-block'>
						
							<img class="embImg" src="http://static.naver.net/m/auto/img/emblem/mnfco_35.png" data-src="http://static.naver.net/m/auto/img/emblem/mnfco_35.png" width="35px" height="35px" alt="링컨">
							<p class="company">링컨</p>
						
					</div>
					<div class='ui-block-e grid-block'>
						
							<img class="embImg" src="http://static.naver.net/m/auto/img/emblem/mnfco_6434.png" data-src="http://static.naver.net/m/auto/img/emblem/mnfco_6434.png" width="35px" height="35px" alt="마이바흐">
							<p class="company">마이바흐</p>
						
					</div>
				</div>
				<div class="ui-grid-d">
					<div class='ui-block-a grid-block'>
						
							<img class="embImg" src="http://static.naver.net/m/auto/img/emblem/mnfco_42.png" data-src="http://static.naver.net/m/auto/img/emblem/mnfco_42.png" width="35px" height="35px" alt="마쯔다">
							<p class="company">마쯔다</p>
						
					</div>
					<div class='ui-block-b grid-block'>
						
							<img class="embImg" src="http://static.naver.net/m/auto/img/emblem/mnfco_44.png" data-src="http://static.naver.net/m/auto/img/emblem/mnfco_44.png" width="35px" height="35px" alt="머큐리">
							<p class="company">머큐리</p>
						
					</div>
					<div class='ui-block-c grid-block'>
						
							<img class="embImg" src="http://static.naver.net/m/auto/img/emblem/mnfco_37.png" data-src="http://static.naver.net/m/auto/img/emblem/mnfco_37.png" width="35px" height="35px" alt="미쓰비시">
							<p class="company">미쓰비시</p>
						
					</div>
					<div class='ui-block-d grid-block'>
						
							<img class="embImg" src="http://static.naver.net/m/auto/img/emblem/mnfco_43.png" data-src="http://static.naver.net/m/auto/img/emblem/mnfco_43.png" width="35px" height="35px" alt="뷰익">
							<p class="company">뷰익</p>
						
					</div>
					<div class='ui-block-e grid-block'>
						
							<img class="embImg" src="http://static.naver.net/m/auto/img/emblem/mnfco_29.png" data-src="http://static.naver.net/m/auto/img/emblem/mnfco_29.png" width="35px" height="35px" alt="사브">
							<p class="company">사브</p>
						
					</div>
				</div>
				<div class="ui-grid-d">
					<div class='ui-block-a grid-block'>
						
							<img class="embImg" src="http://static.naver.net/m/auto/img/emblem/mnfco_4216.png" data-src="http://static.naver.net/m/auto/img/emblem/mnfco_4216.png" width="35px" height="35px" alt="사이언">
							<p class="company">사이언</p>
						
					</div>
					<div class='ui-block-b grid-block'>
						
							<img class="embImg" src="http://static.naver.net/m/auto/img/emblem/mnfco_46.png" data-src="http://static.naver.net/m/auto/img/emblem/mnfco_46.png" width="35px" height="35px" alt="새턴">
							<p class="company">새턴</p>
						
					</div>
					<div class='ui-block-c grid-block'>
						
							<img class="embImg" src="http://static.naver.net/m/auto/img/emblem/mnfco_6436.png" data-src="http://static.naver.net/m/auto/img/emblem/mnfco_6436.png" width="35px" height="35px" alt="스마트">
							<p class="company">스마트</p>
						
					</div>
					<div class='ui-block-d grid-block'>
						
							<img class="embImg" src="http://static.naver.net/m/auto/img/emblem/mnfco_47.png" data-src="http://static.naver.net/m/auto/img/emblem/mnfco_47.png" width="35px" height="35px" alt="스바루">
							<p class="company">스바루</p>
						
					</div>
					<div class='ui-block-e grid-block'>
						
							<img class="embImg" src="http://static.naver.net/m/auto/img/emblem/mnfco_45.png" data-src="http://static.naver.net/m/auto/img/emblem/mnfco_45.png" width="35px" height="35px" alt="스즈키">
							<p class="company">스즈키</p>
						
					</div>
				</div>
				<div class="ui-grid-d">
					<div class='ui-block-a grid-block'>
						
							<img class="embImg" src="http://static.naver.net/m/auto/img/emblem/mnfco_3801.png" data-src="http://static.naver.net/m/auto/img/emblem/mnfco_3801.png" width="35px" height="35px" alt="스코다">
							<p class="company">스코다</p>
						
					</div>
					<div class='ui-block-b grid-block'>
						
							<img class="embImg" src="http://static.naver.net/m/auto/img/emblem/mnfco_3999.png" data-src="http://static.naver.net/m/auto/img/emblem/mnfco_3999.png" width="35px" height="35px" alt="알파로메오">
							<p class="company">알파로메오</p>
						
					</div>
					<div class='ui-block-c grid-block'>
						
							<img class="embImg" src="http://static.naver.net/m/auto/img/emblem/mnfco_3827.png" data-src="http://static.naver.net/m/auto/img/emblem/mnfco_3827.png" width="35px" height="35px" alt="애스턴마틴">
							<p class="company">애스턴마틴</p>
						
					</div>
					<div class='ui-block-d grid-block'>
						
							<img class="embImg" src="http://static.naver.net/m/auto/img/emblem/mnfco_32.png" data-src="http://static.naver.net/m/auto/img/emblem/mnfco_32.png" width="35px" height="35px" alt="어큐라">
							<p class="company">어큐라</p>
						
					</div>
					<div class='ui-block-e grid-block'>
						
							<img class="embImg" src="http://static.naver.net/m/auto/img/emblem/mnfco_40.png" data-src="http://static.naver.net/m/auto/img/emblem/mnfco_40.png" width="35px" height="35px" alt="지프">
							<p class="company">지프</p>
						
					</div>
				</div>
				<div class="ui-grid-d">
					<div class='ui-block-a grid-block'>
						
							<img class="embImg" src="http://static.naver.net/m/auto/img/emblem/mnfco_3840.png" data-src="http://static.naver.net/m/auto/img/emblem/mnfco_3840.png" width="35px" height="35px" alt="코닉세그">
							<p class="company">코닉세그</p>
						
					</div>
					<div class='ui-block-b grid-block'>
						
							<img class="embImg" src="http://static.naver.net/m/auto/img/emblem/mnfco_3806.png" data-src="http://static.naver.net/m/auto/img/emblem/mnfco_3806.png" width="35px" height="35px" alt="파가니">
							<p class="company">파가니</p>
						
					</div>
					<div class='ui-block-c grid-block'>
						
							<img class="embImg" src="http://static.naver.net/m/auto/img/emblem/mnfco_36.png" data-src="http://static.naver.net/m/auto/img/emblem/mnfco_36.png" width="35px" height="35px" alt="폰티악">
							<p class="company">폰티악</p>
						
					</div>
					<div class='ui-block-d grid-block'>
						
							<img class="embImg" src="http://static.naver.net/m/auto/img/emblem/mnfco_3990.png" data-src="http://static.naver.net/m/auto/img/emblem/mnfco_3990.png" width="35px" height="35px" alt="허머">
							<p class="company">허머</p>
						
					</div>
					<div class='ui-block-e grid-block'>
						
							<img class="embImg" src="http://static.naver.net/m/auto/img/emblem/mnfco_3785.png" data-src="http://static.naver.net/m/auto/img/emblem/mnfco_3785.png" width="35px" height="35px" alt="홀덴">
							<p class="company">홀덴</p>
						
					</div>
				</div>
				<div class="ui-grid-d">
					<div class='ui-block-a grid-block'>
						
							<img class="embImg" src="http://static.naver.net/m/auto/img/emblem/mnfco_3976.png" data-src="http://static.naver.net/m/auto/img/emblem/mnfco_3976.png" width="35px" height="35px" alt="마세라티">
							<p class="company">마세라티</p>
						
					</div>
					<div class='ui-block-b grid-block'>
						
							<img class="embImg" src="http://static.naver.net/m/auto/img/emblem/mnfco_29611.png" data-src="http://static.naver.net/m/auto/img/emblem/mnfco_29611.png" width="35px" height="35px" alt="GMC">
							<p class="company">GMC</p>
						
					</div>
					<div class='ui-block-c grid-block'>
						
							<img class="embImg" src="http://static.naver.net/m/auto/img/emblem/mnfco_54155.png" data-src="http://static.naver.net/m/auto/img/emblem/mnfco_54155.png" width="35px" height="35px" alt="Great Wall">
							<p class="company">Great Wall</p>
						
					</div>
					<div class='ui-block-d grid-block'>
						
							<img class="embImg" src="http://static.naver.net/m/auto/img/emblem/mnfco_29981.png" data-src="http://static.naver.net/m/auto/img/emblem/mnfco_29981.png" width="35px" height="35px" alt="RUF">
							<p class="company">RUF</p>
						
					</div>
					<div class='ui-block-e grid-block'>
						
							<img class="embImg" src="http://static.naver.net/m/auto/img/emblem/mnfco_52403.png" data-src="http://static.naver.net/m/auto/img/emblem/mnfco_52403.png" width="35px" height="35px" alt="W모터스">
							<p class="company">W모터스</p>
						
					</div>
				</div>
				<div class="ui-grid-d">
					<div class='ui-block-a grid-block'>
						
							<img class="embImg" src="http://static.naver.net/m/auto/img/emblem/mnfco_53301.png" data-src="http://static.naver.net/m/auto/img/emblem/mnfco_53301.png" width="35px" height="35px" alt="국제차량제작">
							<p class="company">국제차량제작</p>
						
					</div>
					<div class='ui-block-b grid-block'>
						
							<img class="embImg" src="http://static.naver.net/m/auto/img/emblem/mnfco_29972.png" data-src="http://static.naver.net/m/auto/img/emblem/mnfco_29972.png" width="35px" height="35px" alt="다이하쓰">
							<p class="company">다이하쓰</p>
						
					</div>
					<div class='ui-block-c grid-block'>
						
							<img class="embImg" src="http://static.naver.net/m/auto/img/emblem/mnfco_47943.png" data-src="http://static.naver.net/m/auto/img/emblem/mnfco_47943.png" width="35px" height="35px" alt="다치아">
							<p class="company">다치아</p>
						
					</div>
					<div class='ui-block-d grid-block'>
						
							<img class="embImg" src="http://static.naver.net/m/auto/img/emblem/mnfco_53987.png" data-src="http://static.naver.net/m/auto/img/emblem/mnfco_53987.png" width="35px" height="35px" alt="돈커부트">
							<p class="company">돈커부트</p>
						
					</div>
					<div class='ui-block-e grid-block'>
						
							<img class="embImg" src="http://static.naver.net/m/auto/img/emblem/mnfco_56237.png" data-src="http://static.naver.net/m/auto/img/emblem/mnfco_56237.png" width="35px" height="35px" alt="드로리언">
							<p class="company">드로리언</p>
						
					</div>
				</div>
				<div class="ui-grid-d">
					<div class='ui-block-a grid-block'>
						
							<img class="embImg" src="http://static.naver.net/m/auto/img/emblem/mnfco_29975.png" data-src="http://static.naver.net/m/auto/img/emblem/mnfco_29975.png" width="35px" height="35px" alt="란치아">
							<p class="company">란치아</p>
						
					</div>
					<div class='ui-block-b grid-block'>
						
							<img class="embImg" src="http://static.naver.net/m/auto/img/emblem/mnfco_40077.png" data-src="http://static.naver.net/m/auto/img/emblem/mnfco_40077.png" width="35px" height="35px" alt="마러시아">
							<p class="company">마러시아</p>
						
					</div>
					<div class='ui-block-c grid-block'>
						
							<img class="embImg" src="http://static.naver.net/m/auto/img/emblem/mnfco_53655.png" data-src="http://static.naver.net/m/auto/img/emblem/mnfco_53655.png" width="35px" height="35px" alt="마잔티">
							<p class="company">마잔티</p>
						
					</div>
					<div class='ui-block-d grid-block'>
						
							<img class="embImg" src="http://static.naver.net/m/auto/img/emblem/mnfco_29977.png" data-src="http://static.naver.net/m/auto/img/emblem/mnfco_29977.png" width="35px" height="35px" alt="마힌드라">
							<p class="company">마힌드라</p>
						
					</div>
					<div class='ui-block-e grid-block'>
						
							<img class="embImg" src="http://static.naver.net/m/auto/img/emblem/mnfco_29978.png" data-src="http://static.naver.net/m/auto/img/emblem/mnfco_29978.png" width="35px" height="35px" alt="맥라렌">
							<p class="company">맥라렌</p>
						
					</div>
				</div>
				<div class="ui-grid-d">
					<div class='ui-block-a grid-block'>
						
							<img class="embImg" src="http://static.naver.net/m/auto/img/emblem/mnfco_29979.png" data-src="http://static.naver.net/m/auto/img/emblem/mnfco_29979.png" width="35px" height="35px" alt="모건">
							<p class="company">모건</p>
						
					</div>
					<div class='ui-block-b grid-block'>
						
							<img class="embImg" src="http://static.naver.net/m/auto/img/emblem/mnfco_50851.png" data-src="http://static.naver.net/m/auto/img/emblem/mnfco_50851.png" width="35px" height="35px" alt="미아일렉트릭">
							<p class="company">미아일렉트릭</p>
						
					</div>
					<div class='ui-block-c grid-block'>
						
							<img class="embImg" src="http://static.naver.net/m/auto/img/emblem/mnfco_30042.png" data-src="http://static.naver.net/m/auto/img/emblem/mnfco_30042.png" width="35px" height="35px" alt="미쯔오카">
							<p class="company">미쯔오카</p>
						
					</div>
					<div class='ui-block-d grid-block'>
						
							<img class="embImg" src="http://static.naver.net/m/auto/img/emblem/mnfco_29989.png" data-src="http://static.naver.net/m/auto/img/emblem/mnfco_29989.png" width="35px" height="35px" alt="복스홀">
							<p class="company">복스홀</p>
						
					</div>
					<div class='ui-block-e grid-block'>
						
							<img class="embImg" src="http://static.naver.net/m/auto/img/emblem/mnfco_58745.png" data-src="http://static.naver.net/m/auto/img/emblem/mnfco_58745.png" width="35px" height="35px" alt="부가티">
							<p class="company">부가티</p>
						
					</div>
				</div>	
				<div class="ui-grid-d">
					<div class='ui-block-a grid-block'>
						
							<img class="embImg" src="http://static.naver.net/m/auto/img/emblem/mnfco_67995.png" data-src="http://static.naver.net/m/auto/img/emblem/mnfco_67995.png" width="35px" height="35px" alt="북기은상">
							<p class="company">북기은상</p>
						
					</div>
					<div class='ui-block-b grid-block'>
						
							<img class="embImg" src="http://static.naver.net/m/auto/img/emblem/mnfco_29982.png" data-src="http://static.naver.net/m/auto/img/emblem/mnfco_29982.png" width="35px" height="35px" alt="살린">
							<p class="company">살린</p>
						
					</div>
					<div class='ui-block-c grid-block'>
						
							<img class="embImg" src="http://static.naver.net/m/auto/img/emblem/mnfco_29984.png" data-src="http://static.naver.net/m/auto/img/emblem/mnfco_29984.png" width="35px" height="35px" alt="세아트">
							<p class="company">세아트</p>
						
					</div>
					<div class='ui-block-d grid-block'>
						
							<img class="embImg" src="http://static.naver.net/m/auto/img/emblem/mnfco_29985.png" data-src="http://static.naver.net/m/auto/img/emblem/mnfco_29985.png" width="35px" height="35px" alt="쉘비">
							<p class="company">쉘비</p>
						
					</div>
					<div class='ui-block-e grid-block'>
						
							<img class="embImg" src="http://static.naver.net/m/auto/img/emblem/mnfco_30040.png" data-src="http://static.naver.net/m/auto/img/emblem/mnfco_30040.png" width="35px" height="35px" alt="쉘비슈퍼카">
							<p class="company">쉘비슈퍼카</p>
						
					</div>
				</div>
				<div class="ui-grid-d">
					<div class='ui-block-a grid-block'>
						
							<img class="embImg" src="http://static.naver.net/m/auto/img/emblem/mnfco_29987.png" data-src="http://static.naver.net/m/auto/img/emblem/mnfco_29987.png" width="35px" height="35px" alt="스파이커">
							<p class="company">스파이커</p>
						
					</div>
					<div class='ui-block-b grid-block'>
						
							<img class="embImg" src="http://static.naver.net/m/auto/img/emblem/mnfco_4057.png" data-src="http://static.naver.net/m/auto/img/emblem/mnfco_4057.png" width="35px" height="35px" alt="스피라">
							<p class="company">스피라</p>
						
					</div>
					<div class='ui-block-c grid-block'>
						
							<img class="embImg" src="http://static.naver.net/m/auto/img/emblem/mnfco_29970.png" data-src="http://static.naver.net/m/auto/img/emblem/mnfco_29970.png" width="35px" height="35px" alt="아바쓰">
							<p class="company">아바쓰</p>
						
					</div>
					<div class='ui-block-d grid-block'>
						
							<img class="embImg" src="http://static.naver.net/m/auto/img/emblem/mnfco_54257.png" data-src="http://static.naver.net/m/auto/img/emblem/mnfco_54257.png" width="35px" height="35px" alt="아브토바즈">
							<p class="company">아브토바즈</p>
						
					</div>
					<div class='ui-block-e grid-block'>
						
							<img class="embImg" src="http://static.naver.net/m/auto/img/emblem/mnfco_29971.png" data-src="http://static.naver.net/m/auto/img/emblem/mnfco_29971.png" width="35px" height="35px" alt="알피나">
							<p class="company">알피나</p>
						
					</div>
				</div>
				<div class="ui-grid-d">
					<div class='ui-block-a grid-block'>
						
							<img class="embImg" src="http://static.naver.net/m/auto/img/emblem/mnfco_55563.png" data-src="http://static.naver.net/m/auto/img/emblem/mnfco_55563.png" width="35px" height="35px" alt="에쿠스 오토모티브">
							<p class="company">에쿠스 오토모티브</p>
						
					</div>
					<div class='ui-block-b grid-block'>
						
							<img class="embImg" src="http://static.naver.net/m/auto/img/emblem/mnfco_53657.png" data-src="http://static.naver.net/m/auto/img/emblem/mnfco_53657.png" width="35px" height="35px" alt="엘레멘탈">
							<p class="company">엘레멘탈</p>
						
					</div>
					<div class='ui-block-c grid-block'>
						
							<img class="embImg" src="http://static.naver.net/m/auto/img/emblem/mnfco_29391.png" data-src="http://static.naver.net/m/auto/img/emblem/mnfco_29391.png" width="35px" height="35px" alt="오펠">
							<p class="company">오펠</p>
						
					</div>
					<div class='ui-block-d grid-block'>
						
							<img class="embImg" src="http://static.naver.net/m/auto/img/emblem/mnfco_29974.png" data-src="http://static.naver.net/m/auto/img/emblem/mnfco_29974.png" width="35px" height="35px" alt="이스즈">
							<p class="company">이스즈</p>
						
					</div>
					<div class='ui-block-e grid-block'>
						
							<img class="embImg" src="http://static.naver.net/m/auto/img/emblem/mnfco_55877.png" data-src="http://static.naver.net/m/auto/img/emblem/mnfco_55877.png" width="35px" height="35px" alt="장링">
							<p class="company">장링</p>
						
					</div>
				</div>
				<div class="ui-grid-d">
					<div class='ui-block-a grid-block'>
						
							<img class="embImg" src="http://static.naver.net/m/auto/img/emblem/mnfco_19376.png" data-src="http://static.naver.net/m/auto/img/emblem/mnfco_19376.png" width="35px" height="35px" alt="젠보">
							<p class="company">젠보</p>
						
					</div>
					<div class='ui-block-b grid-block'>
						
							<img class="embImg" src="http://static.naver.net/m/auto/img/emblem/mnfco_29973.png" data-src="http://static.naver.net/m/auto/img/emblem/mnfco_29973.png" width="35px" height="35px" alt="카르마 오토모티브">
							<p class="company">카르마 오토모티브</p>
						
					</div>
					<div class='ui-block-c grid-block'>
						
							<img class="embImg" src="http://static.naver.net/m/auto/img/emblem/mnfco_18001.png" data-src="http://static.naver.net/m/auto/img/emblem/mnfco_18001.png" width="35px" height="35px" alt="칼슨">
							<p class="company">칼슨</p>
						
					</div>
					<div class='ui-block-d grid-block'>
						
							<img class="embImg" src="http://static.naver.net/m/auto/img/emblem/mnfco_49801.png" data-src="http://static.naver.net/m/auto/img/emblem/mnfco_49801.png" width="35px" height="35px" alt="케이터햄">
							<p class="company">케이터햄</p>
						
					</div>
					<div class='ui-block-e grid-block'>
						
							<img class="embImg" src="http://static.naver.net/m/auto/img/emblem/mnfco_55571.png" data-src="http://static.naver.net/m/auto/img/emblem/mnfco_55571.png" width="35px" height="35px" alt="쿠오로스">
							<p class="company">쿠오로스</p>
						
					</div>
				</div>
				<div class="ui-grid-d">
					<div class='ui-block-a grid-block'>
						
							<img class="embImg" src="http://static.naver.net/m/auto/img/emblem/mnfco_29988.png" data-src="http://static.naver.net/m/auto/img/emblem/mnfco_29988.png" width="35px" height="35px" alt="타타">
							<p class="company">타타</p>
						
					</div>
					<div class='ui-block-b grid-block'>
						
							<img class="embImg" src="http://static.naver.net/m/auto/img/emblem/mnfco_29832.png" data-src="http://static.naver.net/m/auto/img/emblem/mnfco_29832.png" width="35px" height="35px" alt="테슬라">
							<p class="company">테슬라</p>
						
					</div>
					<div class='ui-block-c grid-block'>
						
							<img class="embImg" src="http://static.naver.net/m/auto/img/emblem/mnfco_60645.png" data-src="http://static.naver.net/m/auto/img/emblem/mnfco_60645.png" width="35px" height="35px" alt="포톤">
							<p class="company">포톤</p>
						
					</div>
					<div class='ui-block-d grid-block'>
						
							<img class="embImg" src="http://static.naver.net/m/auto/img/emblem/mnfco_14.png" data-src="http://static.naver.net/m/auto/img/emblem/mnfco_14.png" width="35px" height="35px" alt="한국지엠">
							<p class="company">한국지엠</p>
						
					</div>
					<div class='ui-block-e grid-block'>
						
							<img class="embImg" src="http://static.naver.net/m/auto/img/emblem/mnfco_30039.png" data-src="http://static.naver.net/m/auto/img/emblem/mnfco_30039.png" width="35px" height="35px" alt="헤네시">
							<p class="company">헤네시</p>
						
					</div>
				</div>
			</div>  -->
			<div class='detailSearch'>
				<div class='car-model'>
					<div class='ui-bar ui-bar-c title'>모델</div>
				</div> 
				<div class='car-model cont' data-iconpos="right" data-mini='true'>
					<select name="select-custom-19" class="filterable-select"  id="title-filter-menu" data-native-menu="false">
							<option>차량모델</option>
							<option value="0">전체</option>
							<option value="1">The 1st Option</option>
							<option value="2" >The 2nd Option</option>
							<option value="3" >The 3rd Option</option>
							<option value="4">The 4th Option</option>
							<option value="1">The 1st Option</option>
							<option value="2" >The 2nd Option</option>
							<option value="3" >The 3rd Option</option>
							<option value="4">The 4th Option</option>
							<option value="1">The 1st Option</option>
							<option value="2" >The 2nd Option</option>
							<option value="3" >The 3rd Option</option>
							<option value="4">The 4th Option</option>
							<option value="1">The 1st Option</option>
							<option value="2" >The 2nd Option</option>
							<option value="3" >The 3rd Option</option>
							<option value="4">The 4th Option</option>
							<option value="1">The 1st Option</option>
							<option value="2" >The 2nd Option</option>
							<option value="3" >The 3rd Option</option>
							<option value="4">The 4th Option</option>
							<option value="1">The 1st Option</option>
							<option value="2" >The 2nd Option</option>
							<option value="3" >The 3rd Option</option>
							<option value="4">The 4th Option</option>
							<option value="1">The 1st Option</option>
							<option value="2" >The 2nd Option</option>
							<option value="3" >The 3rd Option</option>
							<option value="4">The 4th Option</option>
							<option value="1">The 1st Option</option>
							<option value="2" >The 2nd Option</option>
							<option value="3" >The 3rd Option</option>
							<option value="4">The 4th Option</option>
							<option value="1">The 1st Option</option>
							<option value="2" >The 2nd Option</option>
							<option value="3" >The 3rd Option</option>
							<option value="4">The 4th Option</option>
							<option value="1">The 1st Option</option>
							<option value="2" >The 2nd Option</option>
							<option value="3" >The 3rd Option</option>
							<option value="4">The 4th Option</option>
					</select>
				</div> 
			</div>
			<div>
				<div class='ui-grid-a'>
					<div class='ui-block-a car-type'>
						<div class='ui-bar ui-bar-c title'>차종</div>
					</div> 
					<div class='ui-block-b car-fure'>
						<div class='ui-bar ui-bar-c title'>연료</div>
					</div>
				</div>
				<div class='ui-grid-a'>
					<div class='ui-block-a car-type cont' data-role="controlgroup" data-iconpos="right" data-mini='true'> 
							<label for="detail-car-type-1">경형</label>
							<input type="checkbox" id="detail-car-type-1" name="detail-car-type-1">
							<label for="detail-car-type-2">소형</label>
							<input type="checkbox" id="detail-car-type-2" name="detail-car-type-1">
							<label for="detail-car-type-3">준중형</label>
							<input type="checkbox" id="detail-car-type-3" name="detail-car-type-1">
							<label for="detail-car-type-4">중형</label>
							<input type="checkbox" id="detail-car-type-4" name="detail-car-type-1">
							<label for="detail-car-type-5">대형</label>
							<input type="checkbox" id="detail-car-type-5" name="detail-car-type-1">
							<label for="detail-car-type-6">스포츠카</label>
							<input type="checkbox" id="detail-car-type-6" name="detail-car-type-1">
					</div>
					<div class='ui-block-b car-fure cont' data-role="controlgroup" data-iconpos="right" data-mini='true'>
							<label for="detail-fure-1">디젤</label>
							<input type="checkbox" id="detail-fure-1" name="detail-fure-1">
							<label for="detail-fure-2">가솔린</label>
							<input type="checkbox" id="detail-fure-2" name="detail-fure-1">
							<label for="detail-fure-3">LPG</label>
							<input type="checkbox" id="detail-fure-3" name="detail-fure-1">
							<label for="detail-fure-4">하이브리드</label>
							<input type="checkbox" id="detail-fure-4" name="detail-fure-1">
							<label for="detail-fure-5">전기</label>
							<input type="checkbox" id="detail-fure-5" name="detail-fure-1">
							<label for="detail-fure-6">수소</label>
							<input type="checkbox" id="detail-fure-6" name="detail-fure-1">
					</div>
				</div>
			</div>
			<div class='ui-bar ui-bar-c title'>외형</div>
			<div>
				<div class='ui-grid-a cont'>
					<div class='ui-block-a' data-role="controlgroup" data-iconpos="right" data-mini='true'> 
							<label for="detail-car-shape-1">세단</label>
							<input type="checkbox" id="detail-car-shape-1" name="detail-car-shape">
							<label for="detail-car-shape-2">해치백</label>
							<input type="checkbox" id="detail-car-shape-2" name="detail-car-shape">
							<label for="detail-car-shape-3">컨버터블</label>
							<input type="checkbox" id="detail-car-shape-3" name="detail-car-shape">
							<label for="detail-car-shape-4">쿠페</label>
							<input type="checkbox" id="detail-car-shape-4" name="detail-car-shape">
							<label for="detail-car-shape-9">트럭</label>
							<input type="checkbox" id="detail-car-shape-9" name="detail-car-shape">
							
					</div>
					<div class='ui-block-b cont' data-role="controlgroup" data-iconpos="right" data-mini='true'>
							<label for="detail-car-shape-5">왜건</label>
							<input type="checkbox" id="detail-car-shape-5" name="detail-car-shape">
							<label for="detail-car-shape-6">SUV</label>
							<input type="checkbox" id="detail-car-shape-6" name="detail-car-shape">
							<label for="detail-car-shape-7">RV</label>
							<input type="checkbox" id="detail-car-shape-7" name="detail-car-shape">
							<label for="detail-car-shape-8">벤</label>
							<input type="checkbox" id="detail-car-shape-8" name="detail-car-shape">
							<label for="detail-car-shape-10">기타</label>
							<input type="checkbox" id="detail-car-shape-10" name="detail-car-shape">
					</div>
				</div>
			</div>
	</div>
<script>
( function( $ ) {
	
	function pageIsSelectmenuDialog( page ) {
		var isDialog = false
			, id = page && page.attr( "id" ); 
		$( ".filterable-select" ).each( function() { 
			if ( $( this ).attr( "id" ) + "-dialog" === id ) { 
				isDialog = true; 
				return false; 
			}
		});
		return isDialog; 
	}
	
	$.mobile.document
		.on( "selectmenucreate", ".filterable-select", function( event ,a,b) { 
			var input, selectmenu = $( event.target )
				, list = $( "#" + selectmenu.attr( "id" ) + "-menu" ) 
				,form = list.jqmData( "filter-form" ); 
			
			if ( !form ) {
				if( event.target.name == 'companyList' ){
					selectmenu.find('option').each(function(i){
						var val = this.value;
						$( list.find("li")[i] ).find('a').addClass('ui-icon-car-comp-'+val+' ui-btn-icon-left ui-nodisc-icon')
					});
				}
				input = $( "<input data-type='search' class='keyword'></input>" ); 
				form = $( "<form></form>" ).append( input ); 
				input.textinput(); 
				list
					.before( form )
					.jqmData( "filter-form", form );
				form.jqmData( "listview", list ); 
			}
			
			//실질적으로 필터링하는 함수
			selectmenu
				.filterable({
					input: input
					,children: "> option[value]"
				})
				.on( "filterablefilter", function(event,b,c) {
					selectmenu.selectmenu( "refresh" );
					list.find('li:not(.ui-screen-hidden)').each(function(){
						var t = $(this) 
							, idx = t.attr('data-option-index') 
							, val = selectmenu.find('option:eq('+idx+')').val();
						t.find('a').addClass('ui-icon-car-comp-'+val+' ui-btn-icon-left ui-nodisc-icon');
					});
				});
			
			selectmenu.on('change',function(e){
				$(this).find('.ui-screen-hidden').removeClass('ui-screen-hidden')
				selectmenu.selectmenu('refresh');
			});
		})
		.on( "pagecontainerbeforeshow", function( event, data ) {
	        var listview, form;
			if ( !pageIsSelectmenuDialog( data.toPage ) ) {
				return;
			}
			listview = data.toPage.find( "ul" );
			form = listview.jqmData( "filter-form" );
			data.toPage.jqmData( "listview", listview );
			listview.before( form );
	    })
		.on( "pagecontainerhide", function( event, data ) {
			var listview, form;
			if ( !pageIsSelectmenuDialog( data.toPage ) ) {
				return;
			}
			listview = data.toPage.jqmData( "listview" );
			form = listview.jqmData( "filter-form" );
			listview.before( form );
		})
		//**********************
		.on("pagebeforechange",function(event,data){
			if( data.prevPage && data.prevPage.hasClass('ui-selectmenu')){
				$("#detailSearch").panel('open');
			}
		});
})( jQuery );
</script>