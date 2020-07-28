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
<title>JSP 계층형  게시판 글쓰기 처리</title>
</head>
<body>
	<%
		request.setCharacterEncoding("UTF-8");
	
		String writer = StringUtils.nvl(request.getParameter("writer"), "");
		String subject = StringUtils.nvl(request.getParameter("subject"), "");
		String email = StringUtils.nvl(request.getParameter("email"), "");
		String content = StringUtils.nvl(request.getParameter("content"), "");
		String passwd = StringUtils.nvl(request.getParameter("passwd"), "");
		
		String num = StringUtils.nvl(request.getParameter("num"), "");
		String ref = StringUtils.nvl(request.getParameter("ref"), "");
		String re_step = StringUtils.nvl(request.getParameter("re_step"), "");
		String re_level = StringUtils.nvl(request.getParameter("re_level"), "");
		
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		try {
			
			String jdbcUrl = "jdbc:mysql://localhost:3306/jspbeginner";
			String dbId = "jspid";
			String dbPass = "jsppass";
			
			int dbRef = 0;
			int dbRefStep = 0;
			int dbRefLevel = 0;
			
			String sql = "";
			
			Class.forName("com.mysql.cj.jdbc.Driver");
			
			conn = DriverManager.getConnection(jdbcUrl, dbId, dbPass);
			
			if (StringUtils.isEmpty(ref)) { // 새 원본 글 등록
				
				/* System.out.println("writer : " + writer);
				System.out.println("subject : " + subject);
				System.out.println("email : " + email);
				System.out.println("content : " + content);
				System.out.println("passwd : " + passwd); */
				
				sql = "select max(ref) as ref from board";
				pstmt = conn.prepareStatement(sql);
				rs = pstmt.executeQuery();
				
				if (rs.next()) {
					dbRef = rs.getInt("ref") + 1;
				} else {
					dbRef = 1;
				}
				
				dbRefStep = 1;
				dbRefLevel = 1;
				
			} else { 
				
				sql = "update board set re_step=re_step+1 where ref=? and re_step > ?";
				pstmt = conn.prepareStatement(sql);
				pstmt.setInt(1, Integer.parseInt(ref));
				pstmt.setInt(2, Integer.parseInt(re_step));
				pstmt.executeUpdate();
				
				dbRef = Integer.parseInt(ref);
				dbRefStep = Integer.parseInt(re_step) + 1;
				dbRefLevel = Integer.parseInt(re_level) + 1;
			}
						
			StringBuilder sb = new StringBuilder();
			sb.append("insert into board ( ");
			sb.append("writer, email, subject, passwd, reg_date, ");
			sb.append("ref, re_step, re_level, content, ip) ");
			sb.append("values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?) ");
			
			pstmt = conn.prepareStatement(sb.toString());
			pstmt.setString(1, writer);
			pstmt.setString(2, email);
			pstmt.setString(3, subject);
			pstmt.setString(4, Sha256Utils.makeSHA256Key(passwd));
			pstmt.setTimestamp(5, new Timestamp(System.currentTimeMillis()));
			pstmt.setInt(6, dbRef);
			pstmt.setInt(7, dbRefStep);
			pstmt.setInt(8, dbRefLevel);
			pstmt.setString(9, content);
			pstmt.setString(10, request.getRemoteAddr());
			pstmt.executeUpdate();
			
			if (StringUtils.isEmpty(ref)) { // 새 원본 글 등록
		%>
			<script>
				alert('글이 등록되었습니다.');
				location.href = 'list.jsp';
			</script>
		
		<%		
			} else {
		%>
			<script>
				alert('답변글이 등록되었습니다.');
				location.href = 'list.jsp';
			</script>
		
		<%		
			}
			
			//response.sendRedirect("list.jsp");
			
		} catch (Exception e) {
			//e.printStackTrace();
		} finally {
			if (rs != null) try {rs.close();} catch(SQLException sqle) {}
			if (pstmt != null) try {pstmt.close();} catch(SQLException sqle) {}
			if (conn != null) try {conn.close();} catch(SQLException sqle) {}
		}
	%>
</body>
</html>