<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<script>var CONTEXT_PATH="<%=request.getContextPath() %>"</script>
<script src="<%=request.getContextPath() %>/resources/js/jquery-1.12.0.min.js"></script>
<script src="<%=request.getContextPath() %>/resources/js/jquery-ui.min.js"></script>
<script src="<%=request.getContextPath() %>/resources/js/jquery.ui.touch-punch.js"></script>

<script src="<%=request.getContextPath() %>/resources/js/lib/uc-com-lib.js"></script>
<script src="<%=request.getContextPath() %>/resources/js/lib/uc-data-lib.js"></script>
<script src="<%=request.getContextPath() %>/resources/js/lib/uc-date-lib.js"></script>
<script src="<%=request.getContextPath() %>/resources/js/lib/uc-num-lib.js"></script>
<script src="<%=request.getContextPath() %>/resources/js/lib/uc-str-lib.js"></script>
<script src="<%=request.getContextPath() %>/resources/js/lib/uc-form-lib.js"></script>
<script src="<%=request.getContextPath() %>/resources/js/cmm/common.js"></script>
<script>
/** jquery Mobile init  */
$(document).ready(function(){
	$(".header").attr({
		"data-role":"header"
		,'data-position':'fixed'
// 		,'data-fullscreen':true
	});
	$(".footer").attr({
		"data-role":"footer"
			,'data-position':'fixed'
//	 		,'data-fullscreen':true
		});
});
</script>
<link rel="stylesheet" href="<%=request.getContextPath() %>/resources/css/jquery-ui.css">
<link rel="stylesheet" href="<%=request.getContextPath() %>/resources/css/jquery.mobile-1.4.5.css">
<link rel="stylesheet" href="<%=request.getContextPath() %>/resources/css/common.css">
<script src="<%=request.getContextPath() %>/resources/js/jquery.mobile-1.4.5.min.js"></script>
