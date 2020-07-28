package util;

import java.security.MessageDigest;

public class Sha256Utils {

	/**
	 * SHA256형태로 암호화
	 * @param str
	 * @return String
	 * @throws Exception
	 */
	public static String makeSHA256Key(String str) throws Exception {
		String password = str;
 		byte abyte1[];

		MessageDigest md = MessageDigest.getInstance("SHA-256");
		md.reset();

		md.update(password.getBytes("UTF-8"));

		abyte1 = md.digest();

		StringBuffer sb = new StringBuffer();
		String hex = "";

		for (int i=0;i < abyte1.length; i++) {
			hex=Integer.toHexString(0xff & abyte1[i]);
			if(hex.length()==1) sb.append('0');
			sb.append(hex);
		}
		return sb.toString();
	}
	
}
