<%@ page import="java.security.MessageDigest"%>
<%@ page import="java.util.Date"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="java.util.HashMap"%>
<%@ page import="java.sql.ResultSetMetaData"%>
<%@ page import="java.util.Map"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.List"%>
<%@ page import="java.sql.SQLException"%>
<%@ page import="java.sql.Timestamp"%>
<%@ page import="java.sql.DriverManager"%>
<%@ page import="java.sql.ResultSet"%>
<%@ page import="java.sql.PreparedStatement"%>
<%@ page import="java.sql.Connection"%>
<%@ page import="util.ObjectUtils" %>
<%@ page import="util.StringUtils" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	
	request.setCharacterEncoding("UTF-8");

	String pageNum = StringUtils.nvl(request.getParameter("page"), "");
	String field = StringUtils.nvl(request.getParameter("field"), "");
	String keyword = StringUtils.nvl(request.getParameter("keyword"), "");

	Connection conn = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	
	List<Map<String, Object>> list = null;
	
	SimpleDateFormat sdf = new SimpleDateFormat("yyyy.MM.dd HH:mm");
	SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		
	if (StringUtils.isEmpty(pageNum))
		pageNum = "1";
	
	int pageSize = 10;
	
	int currentPage = Integer.parseInt(pageNum);
	int startRow = ((currentPage - 1) * pageSize);
	int endRow = pageSize;
	int count = 0;
	int number = 0;
	
	try {
		
		String jdbcUrl = "jdbc:mysql://localhost:3306/jspbeginner";
		String dbId = "jspid";
		String dbPass = "jsppass";
		
		String sql = "";
		
		Class.forName("com.mysql.cj.jdbc.Driver");
		conn = DriverManager.getConnection(jdbcUrl, dbId, dbPass);
		
		sql = "select count(*) from board ";
		
		sql = sql + "";
		
		if (StringUtils.isNotEmpty(keyword)) {
			sql += "where "+ field +" like '%"+ keyword +"%' ";
		}
		
		pstmt = conn.prepareStatement(sql);
		rs = pstmt.executeQuery();

		if (rs.next()) 
			count = rs.getInt(1);
		else
			count = 0;
		
		//System.out.println(sql);
		
		/* System.out.println("pageNum : " + pageNum);
		System.out.println("count : " + count);
		System.out.println("currentPage : " + currentPage);
		System.out.println("pageSize : " + pageSize);
		System.out.println("startRow : " + startRow);
		System.out.println("endRow : " + endRow); */
		
		//sql = "select * from board order by ref desc, re_step asc limit ?, ?";
		//sql = "select * from board order by ref desc, re_step asc limit ? offset ?";
		
		StringBuilder sb = new StringBuilder();
	
		sb.append("select * from board ");
		
		if (StringUtils.isNotEmpty(keyword)) {
			sb.append("where "+ field +" like '%"+ keyword +"%' ");
		}
		
		sb.append("order by ref desc, re_step asc ");
		sb.append("limit ? offset ?");
		
		System.out.println(count);
		
		pstmt = conn.prepareStatement(sb.toString());
		pstmt.setInt(1, endRow);
		pstmt.setInt(2, startRow);
		rs = pstmt.executeQuery();
		
		list = new ArrayList<Map<String,Object>>();
		
		StringBuilder icon = new StringBuilder();
	
		try {
            
            if( rs.next() ){
            	
            	int j = 0;
            	
            	Date d1 = null;
        		Date d2 = null;
            	
                do{
                	Map<String, Object> map = new HashMap<String, Object>();
                     
                    ResultSetMetaData rsMD= rs.getMetaData();
                    int rsMDCnt = rsMD.getColumnCount();
                    for(int i =1; i <= rsMDCnt; i++ ) {                   
                        String column = rsMD.getColumnName(i).toLowerCase();
                        String value  = rs.getString(column);
                        
                        map.put(column, value);
                        
                        // 총카운트 - ((한페이지에 보여지는 게시물 수 * (현재페이지번호 - 1)) + 인덱스번호)
                        
                    }
                    
                    number = count - ((pageSize * (currentPage - 1)) + j);
                    map.put("number", number);
                    
        			// 답변글 아이콘
                    int width = 0;
                    
                    icon.setLength(0); // 초기화
                    
                    if (Integer.parseInt(map.get("re_level").toString()) > 1) {
                    	width = 5 * Integer.parseInt(map.get("re_level").toString());
                    	
                    	icon.append("<img src=\"images/level.gif\" width=\""+ width +"\">");
                    	icon.append("<img src=\"images/re.gif\">");
                    }
                    
                 	// 새글 아이콘
                    d1 = format.parse(format.format(Timestamp.valueOf(map.get("reg_date").toString())));
        			d2 = format.parse(format.format(System.currentTimeMillis()));

        			//in milliseconds
        			long diff = d2.getTime() - d1.getTime();
        			
        			//diffHours = diff / (60 * 60 * 1000) % 24;
        			
        			//System.out.println(diff + " : " + d1 + " : " + d2 + " : " + diffHours);
        			
        			long diffSeconds = diff / 1000 % 60;
        			long diffMinutes = diff / (60 * 1000) % 60;
        			long diffHours = diff / (60 * 60 * 1000) % 24;
        			long diffDays = diff / (24 * 60 * 60 * 1000);
        			
        			// (int) ((milliseconds / (1000*60*60)) % 24);//시

        			/* System.out.print(diffDays + " days, ");
        			System.out.print(diffHours + " hours, ");
        			System.out.print(diffMinutes + " minutes, ");
        			System.out.print(diffSeconds + " seconds."); 
        			System.out.println(); */
        			
        			if (diffDays == 0 && diffHours <= 1) {
        				icon.append("<img src=\"images/hot.gif\">");
        			}
                    
                    map.put("icon", icon.toString());

                    j++;
                    
                    //System.out.println(map);
                     
                    list.add(map);
                }while(rs.next());
                 
                //System.out.println(list);
                
            }else{
                list = java.util.Collections.EMPTY_LIST;
            }
             
             
        }catch (Exception e) {                
            list = null;
        }
		
	} catch (Exception e) {
		
	} finally {
		if (rs != null) try {rs.close();} catch(SQLException sqle){}
		if (pstmt != null) try {pstmt.close();} catch(SQLException sqle) {}
		if (conn != null) try {conn.close();} catch(SQLException sqle) {}
	}
	
	//System.out.println(list);
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
<title>JSP 계층형  게시판 리스트</title>
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

.searchbox {
	text-align:right;
}

.searchbox select, input {
	height:35px;
}

</style>
</head>
<body>
	<div class="container">
		<h2 class="text-center">JSP 계층형  게시판 리스트</h2>
		<form name="searchform" name="get" action="list.jsp">
			<table class="table table-bordered table table-hover searchbox"> 
				<tbody>
					<tr>
						<td>
							<select name="field">
								<option value="subject" <% if (field.equals("subject")) { %>selected="selected"<% } %>>제목</option>
								<option value="writer" <% if (field.equals("writer")) { %>selected="selected"<% } %>>작성자</option>
							</select>
							<input type="text" size="25%" value="<%=keyword %>" name="keyword" maxlength="10">
							<input type="submit" value="검색">
							<input type="hidden" value="1" name="page">
						</td>
					</tr>
				</tbody>
			</table>
		</form>
		<table class="table table-bordered table table-hover"> 
			<thead> 
				<tr> 
					<th>번호</th> 
					<th>제목 </th> 
					<th>작성자</th>
					<th>작성일</th>
					<th>조회</th>
					<th>IP</th>
				</tr>
			</thead> 
			<tbody>
				<%
					if (!ObjectUtils.isEmpty(list)) {
						
						for(Map<String, Object> map : list) {
							
							//System.out.println(map.get("reg_date").getClass().getName());
							//System.out.println(Timestamp.valueOf(map.get("reg_date").toString()).getClass().getName());
				%>
				<tr>
					<td><%=map.get("number") %></td>
					<td><%=map.get("icon") %><a href="content.jsp?num=<%=map.get("num") %>&page=<%=pageNum%>&field=<%=field%>&keyword=<%=keyword%>"><%=map.get("subject") %></a></td>
					<td><%=map.get("writer") %></td>
					<td><%=sdf.format(Timestamp.valueOf(map.get("reg_date").toString())) %></td>
					<td><%=map.get("readcount") %></td>
					<td><%=map.get("ip") %></td>
				</tr>
				<%
						}
					} else {
				%>
				<tr>
					<td colspan="6" align="center">
						저장된 글이 없습니다.
					</td>
				</tr>
				<%
					}
				%>
			</tbody>
			<tfoot>
				<tr>
					<td>
						<input type="button" value="글쓰기" onclick="location.href='write.jsp'">
					</td>
					<td colspan="5" align="center">
						<%
							if (count > 0) {
								
								int pageBlock = 5;
								
								int pageCount = (count / pageSize) + (count % pageSize == 0 ? 0 : 1);
								
								int block_num = (currentPage / pageBlock) + (currentPage % pageBlock == 0 ? 0 : 1);
								
								//int startPage = (int)(((currentPage / pageSize) * pageSize) + 1);
								//int startPage = ((currentPage / pageCount) * pageSize)+1;
								//int startPage = (int)Math.ceil(currentPage / pageCount) * pageSize + 1;
								int startPage = ((block_num -1) * pageBlock) + 1;
								
								int endPage = (startPage + pageBlock) - 1;
								
								if (endPage > pageCount) endPage = pageCount;
								
								/* System.out.println("currentPage : " + currentPage);
								System.out.println("block_num : " + block_num);
								System.out.println("pageCount : " + pageCount);
								System.out.println("startPage : " + startPage);
								System.out.println("endPage : " + endPage);
								System.out.println("--------------------------------"); */
								
								if (startPage > block_num) {
						%>
									<a href="list.jsp?page=<%=startPage - pageBlock%>">[이전]</a>
						<%
								}		
						
								for (int i = startPage; i <= endPage; i++) {
						%>
									<a href="list.jsp?page=<%=i%>">[<%=i %>]</a>
						<%
								}
								
								if (endPage < pageCount) {
						%>
									<a href="list.jsp?page=<%=startPage + pageBlock%>">[다음]</a>
						<%		
								}
							}
						%>
					</td>
				</tr>
			</tfoot> 
		</table>
	</div>
</body>
</html>