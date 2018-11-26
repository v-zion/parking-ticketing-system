

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * Servlet implementation class MainCarInfo
 */
@WebServlet("/MainCarInfo")
public class MainCarInfo extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public MainCarInfo() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
//		response.getWriter().append("Served at: ").append(request.getContextPath());
		String p = "with owners(name,uid,ifparked) as "
				+ "(select users.name as name, users.uid as uid, 0 from owns natural join users where cid = ? "
				+ "except (select users.name,users.uid,0 from payer natural join users)), "
				+ "paid(name,uid,ifparked) as "
				+ "(select users.name,users.uid,1 from users natural join payer where payer.cid=?) "
				+ "select * from paid union owners";
		HttpSession session = request.getSession();
		if (session.getAttribute("id") == null) {
			response.getWriter().print(DbHelper.errorJson("Not logged in").toString());
			return;
		}
		String cid = (String) request.getParameter("cid");
		String res = DbHelper.executeQueryJson(p, 
				new DbHelper.ParamType[] {DbHelper.ParamType.STRING,DbHelper.ParamType.STRING}, 
				new String[] {cid,cid});
		response.getWriter().print(res);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
