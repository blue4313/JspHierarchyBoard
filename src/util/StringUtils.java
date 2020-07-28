package util;

public class StringUtils {
	
	/**
	 * 대상 Object가 널이면 기본 빈물자열이 리턴이 되며 널이 아닐경우 입력 파라미터를 ToString() 처리 한다.
	 * @param object : ToString 대상 Object
	 * @return parameter objecct.ToString() 
	 */
	public static String nvl(Object object) {
		return object != null ? object.toString() : "";
	}
		
	/**
	 * 문자열이 null 일때 임의의 문자열을 반환한다.
	 * @param  String value, String defaultValue
	 * @return String
	 * @throws
	 */
	public static String nvl(String value, String defaultValue) {
	    return (value == null || "".equals(value)) ? defaultValue : value.trim();
	}

	public static String nvl(Object o, String defaultValue) {
	    return (o == null) ? defaultValue : o.toString().trim();
	}
	
	/**
	 * 문자열이 NULL 이거나 "" 이면 true
	 * @param s
	 * @return boolean
	 */
	public static boolean isEmpty(String s) {
		return s == null || s.equals("") ? true : false;
	}
	/**
	 * 문자열이 NULL 이 아니고 "" 도 아니면 true
	 * @param s
	 * @return boolean
	 */
	public static boolean isNotEmpty(String s) {
		return !isEmpty(s);
	}
	
	public static String convertHtml(String str) {
		String resultStr = "";
		if(str==null||str.equals("")) {
			return str;
		}

		
		resultStr = str.replaceAll("<", "&lt;");
		resultStr = str.replaceAll(">", "&gt;");
		resultStr = str.replaceAll("\"", "&quot;");
		return resultStr;
	}
	
	
	public static String convertView(String str){
		
		if(str==null||str.equals("")) {
			return str;
		}
		
		str = str.trim();
		str = str.replaceAll("&amp;", "&");
		str = str.replaceAll("&#37;", "%");
		str = str.replaceAll("\r\n", "<br />");
		return str;
	}
	
	
	/**
	 * 문자열 바꾸기.
	 * @param s
	 * @param template
	 * @return String
	 */
	public static String replaceTemplate(String s, String[] template) {
		for (int i = 0; i < template.length; i++) {
			s = s.replaceAll("\\{"+(i+1)+"\\}", template[i]);
		}
		return s;
	}
	
	
	public static String reconvertHtml(String str) {
		String resultStr = "";
		if(str==null||str.equals("")) {
			return str;
		}
		
		resultStr = str.replaceAll("&lt;", "<");
		resultStr = str.replaceAll("&gt;", ">");
		resultStr = str.replaceAll("&quot;", "\"");
		return resultStr;
	}
	
	
	
}
