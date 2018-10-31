

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * Servlet implementation class NewUserRegisteration
 */
@WebServlet("/NewUserRegisteration")
public class NewUserRegisteration extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public NewUserRegisteration() {
        super();
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		HttpSession session = request.getSession();
		String userID = request.getParameter("uid");
		String name = request.getParameter("name");
		String phoneNum = request.getParameter("phone");
		String userType = request.getParameter("class");
		
		String newUserQuery = "insert into users (uid, name, phone, class) " + "values (?, ?, ?, ?)"
				+ "where not exists (select * from users where uid = ?";
		
		String json = DbHelper.executeUpdateJson(newUserQuery, new DbHelper.ParamType[]
				{DbHelper.ParamType.STRING, DbHelper.ParamType.STRING, DbHelper.ParamType.STRING, 
				DbHelper.ParamType.STRING,DbHelper.ParamType.STRING},
				new String[] {userID, name, phoneNum, userType, userID});
		
		response.getWriter().print(json);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doGet(request, response);
	}

}
