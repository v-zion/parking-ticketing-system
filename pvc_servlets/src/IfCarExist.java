

import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * Servlet implementation class IfCarExist
 */
@WebServlet("/IfCarExist")
public class IfCarExist extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public IfCarExist() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		HttpSession session = request.getSession();
		if (session.getAttribute("id") == null) {
			response.getWriter().print(DbHelper.errorJson("Not logged in").toString());
			return;
		}
		String cid = (String) request.getParameter("cid");
		String available_cars = "(select owns.cid from car where cid = ?)";
		List<List<Object>> res = DbHelper.executeQueryList(available_cars, 
				new DbHelper.ParamType[] {DbHelper.ParamType.STRING}, 
				new String[] {cid});
//		response.getWriter().print(res);
		String dbPass = res.isEmpty()? null : (String)res.get(0).get(0);
		if(dbPass != null) {
//			session.setAttribute("id", userid);
			response.getWriter().print(DbHelper.okJson().toString());
		}
		else {
			response.getWriter().print(DbHelper.errorJson("Username/password incorrect").toString());
		}	
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
