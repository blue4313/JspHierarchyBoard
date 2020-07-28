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
		
		sql = "update board set readcount=readcount+1 where num=?";
		pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, Integer.parseInt(num));
		pstmt.executeUpdate();
		
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
<title>JSP 계층형  게시판 글내용</title>
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
function check(mode){
	
	if (mode == "rewrite") {
		
		document.writeform.action = "write.jsp";
		
		if (!confirm("답변글을 등록하시겠습니까?")) {
			return false;
		}
		
	} else if (mode == "delete") {
		
		document.writeform.action = "delete_ok.jsp";
		
		if(!document.writeform.passwd.value){
		  alert(" 비밀번호를 입력하십시요.");
		  writeform.passwd.focus();
		  return false;
		}
		
		if (!confirm("글을 삭제하시겠습니까?")) {
			return false;
		}
	}
	
	document.writeform.submit();
 }
</script>
</head>
<body>
	<div class="container">
		<h2 class="text-center">JSP 계층형  게시판 글내용</h2>
		<form name="writeform" method="post">
			<input type="hidden" value="<%=map.get("num") %>" name="num">
			<input type="hidden" value="<%=map.get("ref") %>" name="ref">
			<input type="hidden" value="<%=map.get("re_step") %>" name="re_step">
			<input type="hidden" value="<%=map.get("re_level") %>" name="re_level">
			<table class="table table-bordered table table-hover"> 
				<tbody> 
					<tr>
						<td>번호</td>
						<td><%=map.get("num") %></td>
						<td>조회</td>
						<td><%=map.get("readcount") %></td>
					</tr>
					<tr>
						<td>작성자</td>
						<td><%=map.get("writer") %></td>
						<td>작성일</td>
						<td><%=sdf.format(Timestamp.valueOf(map.get("reg_date").toString())) %></td>
					</tr>
					<tr>
						<td>제 목</td>
						<td colspan="3"><%=map.get("subject") %></td>
					</tr>
					<tr>
						<td>이메일</td>
						<td colspan="3"><%=map.get("email") %></td>
					</tr>
					<tr>
						<td>내 용</td>
						<td colspan="3">
						
							<!-- 
							1. System.out.format() 을 이용하여 %n 개행 처리.
							이렇게하면 운영체제 에 맞게 처리된다.
							
							2. (String타입 변수명).replace("\n","\r\n")
							이렇게하면 윈도우 호환에 맞게끔 처리할 수 있다.
							
							3. String line = System.getProperty("line.separator");
							str = str.replace("\n", line); 
							
							윈도우 : \r\n
							리눅스 : \n
							String newline = System.getProperty("line.separator"); 
							
							// Java 1.7+ 
							String newline = System.lineSeparator();
							
							-->
							
							<%=map.get("content").toString().replace(System.lineSeparator(), "<br>") %>
						</td>
					</tr>
					<tr>
						<td>비밀번호</td>
						<td colspan="3"><input type="password" size="25%" name="passwd" maxlength="12"></td>
					</tr>
					<tr>
						<td colspan="4" align="center">						
							<input type="button" value="글수정" onclick="location.href='edit.jsp?num=<%=map.get("num") %>&page=<%=pageNum%>'">
							<input type="button" value="글삭제" onclick="check('delete');">
							<input type="button" value="답변쓰기" onclick="check('rewrite');">
							<input type="button" value="목록보기" onclick="location.href='list.jsp?page=<%=pageNum%>&field=<%=field%>&keyword=<%=keyword%>'">
						</td>
					</tr>
				</tbody> 
			</table>
		</form>
	</div>
</body>
</html>