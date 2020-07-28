<%@ page import="java.sql.Timestamp"%>
<%@ page import="java.sql.ResultSetMetaData"%>
<%@ page import="java.util.Map"%>
<%@ page import="java.util.HashMap"%>
<%@ page import="java.sql.DriverManager"%>
<%@ page import="java.sql.SQLException"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="java.sql.ResultSet"%>
<%@ page import="java.sql.PreparedStatement"%>
<%@ page import="java.sql.Connection"%>
<%@ page import="util.StringUtils" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	request.setCharacterEncoding("UTF-8");

	String num = StringUtils.nvl(request.getParameter("num"), "");
	String pageNum = StringUtils.nvl(request.getParameter("page"), "");
	String field = StringUtils.nvl(request.getParameter("field"), "");
	String keyword = StringUtils.nvl(request.getParameter("keyword"), "");
	
	Connection conn = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	
	Map<String, Object> map = new HashMap<String, Object>();
	
	SimpleDateFormat sdf = new SimpleDateFormat("yyyy.MM.dd HH:mm");
	
	try {
		
		String jdbcUrl = "jdbc:mysql://localhost:3306/jspbeginner";
		String dbId = "jspid";
		String dbPass = "jsppass";
		
		String sql = "";
		
		Class.forName("com.mysql.cj.jdbc.Driver");
		conn = DriverManager.getConnection(jdbcUrl, dbId, dbPass);
		
		sql = "select * from board where num=?";
		pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, Integer.parseInt(num));
		rs = pstmt.executeQuery();
		
		try {
			
			if( rs.next() ){
				
				ResultSetMetaData rsMD= rs.getMetaData();
	            int rsMDCnt = rsMD.getColumnCount();
	            for(int i =1; i <= rsMDCnt; i++ ) {                   
	                String column = rsMD.getColumnName(i).toLowerCase();
	                String value  = rs.getString(column);
	                                     
	                map.put(column, value);
	            }
	            
	            System.out.println(map);
	            
			}else{
				map = java.util.Collections.EMPTY_MAP;
            }
			
		}catch (Exception e) {                
            map = null;
        }
		
	} catch (Exception e) {
		
	} finally {
		if (rs != null) try {rs.close();} catch(SQLException sqle){}
		if (pstmt != null) try {pstmt.close();} catch(SQLException sqle) {}
		if (conn != null) try {conn.close();} catch(SQLException sqle) {}
	}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
<title>JSP 계층형  게시판 글수정</title>
<link href="//maxcdn.bootstrapcdn.com/bootstrap/latest/css/bootstrap.min.css" rel="stylesheet">
<script src="//ajax.googleapis.com/ajax/libs/jquery/1/jquery.min.js"></script>
<script src="//maxcdn.bootstrapcdn.com/bootstrap/latest/js/bootstrap.min.js"></script>
<style type="text/css">
* { font-family: NanumGothic, 'Malgun Gothic'; }
body { padding-top: 50px; }
.starter-template {
  padding: 40px 15px;
  text-align: center;
}
</style>
<script type="text/javascript">
function check(){
	if(!document.writeform.writer.value){
	  alert("작성자를 입력하십시요.");
	  writeform.writer.focus();
	  return false;
	}
	if(!document.writeform.subject.value){
	  alert("제목을 입력하십시요.");
	  writeform.subject.focus();
	  return false;
	}
	
	if(!document.writeform.content.value){
	  alert("내용을 입력하십시요.");
	  writeform.content.focus();
	  return false;
	}
        
	if(!document.writeform.passwd.value){
	  alert(" 비밀번호를 입력하십시요.");
	  writeform.passwd.focus();
	  return false;
	}
	
	if (!confirm("글을 수정하시겠습니까?")) {
		return false;
	}
 }
</script>
</head>
<body>
	<div class="container">
		<h2 class="text-center">JSP 계층형  게시판 글수정</h2>
		<form name="writeform" method="post" action="edit_ok.jsp" onsubmit="return check();">
			<input type="hidden" value="<%=num %>" name="num">
			<input type="hidden" value="<%=pageNum %>" name="page">
			<table class="table table-bordered table table-hover"> 
				<tbody> 
					<tr>
						<td>이 름</td>
						<td><input type="text" value="<%=map.get("writer").toString().replaceAll("\\\"", "&quot;") %>" size="25%" name="writer" maxlength="10"></td>
					</tr>
					<tr>
						<td>제 목</td>
						<td><input type="text" value="<%=map.get("subject").toString().replaceAll("\\\"", "&quot;") %>" size="100%" name="subject" maxlength="50"></td>
					</tr>
					<tr>
						<td>Email</td>
						<td><input type="text" value="<%=map.get("email").toString().replaceAll("\\\"", "&quot;") %>" size="100%" name="email" maxlength="50"></td>
					</tr>
					<tr>
						<td>내용</td>
						<td><textarea rows="10" cols="100%" name="content" wrap="hard"><%=map.get("content") %></textarea></td>
					</tr>
					<tr>
						<td>비밀번호</td>
						<td><input type="password" size="25%" name="passwd" maxlength="12"></td>
					</tr>
					<tr>
						<td colspan="2" align="center">
							<input type="submit" value="글수정">
							<input type="reset" value="다시작성">
							<input type="button" value="목록보기" onclick="location.href='list.jsp?page=<%=pageNum%>&field=<%=field%>&keyword=<%=keyword%>'">
						</td>
					</tr>
				</tbody> 
			</table>
		</form>
	</div>
</body>
</html>