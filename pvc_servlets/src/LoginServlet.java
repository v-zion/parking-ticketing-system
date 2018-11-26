

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * Servlet implementation class LoginServlet
 */
@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	
    /**
     * @see HttpServlet#HttpServlet()
     */
    public LoginServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		HttpSession session = request.getSession();
		System.out.println("hello");
		if(session.getAttribute("id") != null) { // logged in
			response.getWriter().print(DbHelper.okJson().toString());
		}
		else {
			response.getWriter().print(DbHelper.errorJson("Not logged in"));
		}
		return;
	}

	/**
	 * 
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) 
			throws ServletException, IOException {
		HttpSession session = request.getSession();
		String userid = request.getParameter("userid");
		String password = request.getParameter("password");
		System.out.println(userid);
		System.out.println(password);
		String query = "select password from password where uid = ?";
		String query1 = "select class from users where uid = ?";
		List<List<Object>> res = DbHelper.executeQueryList(query, 
				new DbHelper.ParamType[] {DbHelper.ParamType.STRING}, 
				new Object[] {userid});
		
		
		String dbPass = res.isEmpty()? null : (String)res.get(0).get(0);
		if(dbPass != null && dbPass.equals(password)) {
			session.setAttribute("id", userid);
			String temp = DbHelper.executeQueryJson(query1, 
					new DbHelper.ParamType[] {DbHelper.ParamType.STRING}, 
					new Object[] {userid});
			System.out.println(temp);
			response.getWriter().print(temp);
		}
		else {
			response.getWriter().print(DbHelper.errorJson("Username/password incorrect").toString());
		}
	}

}
