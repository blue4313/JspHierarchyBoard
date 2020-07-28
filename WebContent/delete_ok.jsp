<%@ page import="java.sql.SQLException"%>
<%@ page import="java.sql.DriverManager"%>
<%@ page import="java.sql.ResultSet"%>
<%@ page import="java.sql.PreparedStatement"%>
<%@ page import="java.sql.Connection"%>
<%@ page import="util.StringUtils" %>
<%@ page import="util.Sha256Utils" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>JSP 계층형  게시판 글삭제 처리</title>
</head>
<body>
	<%
		String num = StringUtils.nvl(request.getParameter("num"), "");
		String pageNum = StringUtils.nvl(request.getParameter("page"), "");
		String passwd = StringUtils.nvl(request.getParameter("passwd"), "");
	
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		try {
			
			String jdbcUrl = "jdbc:mysql://localhost:3306/jspbeginner";
			String dbId = "jspid";
			String dbPass = "jsppass";
			
			String sql = "";
			
			Class.forName("com.mysql.cj.jdbc.Driver");
			conn = DriverManager.getConnection(jdbcUrl, dbId, dbPass);
			
			pstmt = conn.prepareStatement("select passwd from board where num=?");
			pstmt.setInt(1, Integer.parseInt(num));
			rs = pstmt.executeQuery();
			
			String sha256Passwd = "";
			byte[] varbinary = null;
			
			if (rs.next()) {
				
				sha256Passwd = Sha256Utils.makeSHA256Key(passwd);
				varbinary = (byte[])rs.getObject("passwd");
				
			}
			
			if (sha256Passwd.equals(new String(varbinary))) {
			
				sql = "delete from board where num=?";
				pstmt = conn.prepareStatement(sql);
				pstmt.setInt(1, Integer.parseInt(num));
				pstmt.executeUpdate();
		
		%>
				<script>
					alert('글이 삭제되었습니다.');
					location.href = 'list.jsp';
				</script>
		
		<%
		
			} else {
				
		%>
				<script>
					alert('비밀번호가 일치하지 않습니다.');
					location.href = 'content.jsp?num=<%=num%>&page=<%=pageNum%>';
				</script>
 		<%
				
			}
		
		} catch (Exception e) {
			
		} finally {
			if (pstmt != null) try {pstmt.close();} catch(SQLException sqle) {}
			if (conn != null) try {conn.close();} catch(SQLException sqle) {}
		}
	%>
</body>
</html>