

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * Servlet implementation class RegisterUser
 */
@WebServlet("/RegisterUser")
public class RegisterUser extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public RegisterUser() {
        super();
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		HttpSession session = request.getSession();
		if(session.getAttribute("id") == null) { //not logged in
			response.getWriter().print(DbHelper.errorJson("Not logged in").toString());
			return;
		}
		
		String userid = (String) request.getParameter("uid");
		String name = (String) request.getParameter("name");
		String phone_number= (String) request.getParameter("phone");
		String userclass= (String) request.getParameter("class");
		String query = 
				"insert into users values (?,?,?,?)";
		String res = DbHelper.executeUpdateJson(query, 
				new DbHelper.ParamType[] { 
						DbHelper.ParamType.STRING,
						DbHelper.ParamType.STRING,
						DbHelper.ParamType.STRING,
						DbHelper.ParamType.INT}, 
					new String[] {userid, name, phone_number, userclass});
		
		String amount="0";
		String query2 = 
				"insert into wallet values (?,?)";
		String res2 = DbHelper.executeUpdateJson(query2, 
				new DbHelper.ParamType[] { 
						DbHelper.ParamType.STRING,
						DbHelper.ParamType.INT}, 
					new String[] {userid,amount});
		
		PrintWriter out = response.getWriter();
		out.print(res);
		
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doGet(request, response);
	}
	
	public static void main(String[] args) throws ServletException, IOException {
		new RegisterUser().doGet(null, null);
	}

}
