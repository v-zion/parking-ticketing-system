

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
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		
		String userid = (String) request.getParameter("uid");
		String name = (String) request.getParameter("name");
		String phone_number= (String) request.getParameter("phone");
		Integer userclass= Integer.parseInt(request.getParameter("class"));
		String password = (String) request.getParameter("password");
		String query = 
				"insert into users values (?,?,?,?)";
		String res = DbHelper.executeUpdateJson(query, 
				new DbHelper.ParamType[] { 
						DbHelper.ParamType.STRING,
						DbHelper.ParamType.STRING,
						DbHelper.ParamType.STRING,
						DbHelper.ParamType.INT}, 
				new Object[] {userid, name, phone_number, userclass});
		
		Integer amount=0;;
		String query2 = 
				"insert into wallet values (?,?)";
		String res2 = DbHelper.executeUpdateJson(query2, 
				new DbHelper.ParamType[] { 
						DbHelper.ParamType.STRING,
						DbHelper.ParamType.INT}, 
				new Object[] {userid,amount});
		
		String query3 = 
				"insert into password values (?,?)";
		String res3 = DbHelper.executeUpdateJson(query3, 
				new DbHelper.ParamType[] { 
						DbHelper.ParamType.STRING,
						DbHelper.ParamType.STRING}, 
				new String[] {userid,password});
		
		PrintWriter out = response.getWriter();
		out.print(res);

	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}
	
	public static void main(String[] args) throws ServletException, IOException {
		new RegisterUser().doGet(null, null);
	}

}