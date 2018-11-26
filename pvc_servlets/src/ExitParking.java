

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * Servlet implementation class ExitParking
 */
@WebServlet("/ExitParking")
public class ExitParking extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public ExitParking() {
        super();
        // TODO Auto-generated constructor stub
    }

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
		String uid = (String) session.getAttribute("id");
		String cid = (String) request.getParameter("cid");
		String findQuery = "select pid, floor_number from parks where cid = ?";
		List<List<Object>> fqres = DbHelper.executeQueryList(findQuery, new DbHelper.ParamType[] {DbHelper.ParamType.STRING}, new String[] {cid});
		String pid = (String)fqres.get(0).get(0);
		String floor = (String)fqres.get(0).get(1);
		String park = "delete from parks where cid=? and pid=? and floor_number=?";
		String reduce = "update parking_floor "
				+ "set free_space = free_space + 1 "
				+ "where pid = ? and floor_number = ?";
		String payer = "delete from payer where cid=? and uid=?";
		String res = DbHelper.executeUpdateJson(park, 
				new DbHelper.ParamType[] { 
						DbHelper.ParamType.STRING,
						DbHelper.ParamType.STRING,
						DbHelper.ParamType.STRING}, 
				new String[] {cid, pid, floor});
		DbHelper.executeUpdateJson(reduce, 
				new DbHelper.ParamType[] { 
						DbHelper.ParamType.STRING,
						DbHelper.ParamType.STRING}, 
				new String[] {pid, floor});
		DbHelper.executeUpdateJson(payer, 
				new DbHelper.ParamType[] { 
						DbHelper.ParamType.STRING,
						DbHelper.ParamType.STRING}, 
				new String[] {cid, uid});
		
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

}
