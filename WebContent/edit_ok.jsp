<%@ page import="java.sql.ResultSet"%>
<%@ page import="java.sql.SQLException"%>
<%@ page import="java.sql.Timestamp"%>
<%@ page import="java.sql.DriverManager"%>
<%@ page import="java.sql.PreparedStatement"%>
<%@ page import="java.sql.Connection"%>
<%@ page import="util.StringUtils" %>
<%@ page import="util.Sha256Utils" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>JSP 계층형  게시판 글수정 처리</title>
</head>
<body>
	<%
		request.setCharacterEncoding("UTF-8");
	
		String num = StringUtils.nvl(request.getParameter("num"), "");
		String pageNum = StringUtils.nvl(request.getParameter("page"), "");
	
		String writer = StringUtils.nvl(request.getParameter("writer"), "");
		String subject = StringUtils.nvl(request.getParameter("subject"), "");
		String email = StringUtils.nvl(request.getParameter("email"), "");
		String content = StringUtils.nvl(request.getParameter("content"), "");
		String passwd = StringUtils.nvl(request.getParameter("passwd"), "");

		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		try {
			
			String jdbcUrl = "jdbc:mysql://localhost:3306/jspbeginner";
			String dbId = "jspid";
			String dbPass = "jsppass";
			
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
			
				StringBuilder sb = new StringBuilder();
				sb.append("update board set ");
				sb.append("writer=?, ");
				sb.append("email=?, ");
				sb.append("subject=?, ");
				sb.append("content=? ");
				sb.append("where num=?");
				
				pstmt = conn.prepareStatement(sb.toString());
				pstmt.setString(1, writer);
				pstmt.setString(2, email);
				pstmt.setString(3, subject);
				pstmt.setString(4, content);
				pstmt.setInt(5, Integer.parseInt(num));
				
				pstmt.executeUpdate();
		
		%>
				<script>
					alert('글이 수정되었습니다.');
					location.href = 'content.jsp?num=<%=num%>&page=<%=pageNum%>';
				</script>
		
		<%
			} else {
				
		%>
				<script>
					alert('비밀번호가 일치하지 않습니다.');
					location.href = 'edit.jsp?num=<%=num%>&page=<%=pageNum%>';
				</script>
 		<%	
				
			}
		
			//response.sendRedirect("content.jsp?num=" + num + "&page=" + pageNum);
			
		} catch (Exception e) {
			//e.printStackTrace();
		} finally {
			if (pstmt != null) try {pstmt.close();} catch(SQLException sqle) {}
			if (conn != null) try {conn.close();} catch(SQLException sqle) {}
		}
	%>
</body>
</html>