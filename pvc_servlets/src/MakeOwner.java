

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.JSONException;
import org.json.JSONObject;

/**
 * Servlet implementation class MakeOwner
 */
@WebServlet("/MakeOwner")
public class MakeOwner extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		HttpSession session = request.getSession();
		if(session.getAttribute("id") == null) { //not logged in
			response.getWriter().print(DbHelper.errorJson("Not logged in").toString());
			return;
		}
		
		String userid = (String) session.getAttribute("id");
		
		String cid = (String) request.getParameter("cid");
		String password = (String) request.getParameter("password");
		
		
		String query = 
				"select * from car where cid=? and password=?";
		
		List<List<Object>> res = DbHelper.executeQueryList(query, 
				new DbHelper.ParamType[] { 
						DbHelper.ParamType.STRING,
						DbHelper.ParamType.STRING
						},
				new String[] {cid,password});
		
		if(!res.isEmpty())
		{
			String query1 = 
			"insert into owns values (?,?)";
			String res1 = DbHelper.executeUpdateJson(query1, 
					new DbHelper.ParamType[] { 
							DbHelper.ParamType.STRING,
							DbHelper.ParamType.STRING
							},
					new String[] {cid,userid});
			
			PrintWriter out = response.getWriter();
			out.print(res1);
		}
		else
		{
			response.getWriter().print(DbHelper.errorJson("This is not your car, u smarty pants :)").toString());
		}
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}
	
	public static void main(String[] args) throws ServletException, IOException {
		new MakeOwner().doGet(null, null);
	}


}
