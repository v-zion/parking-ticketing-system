// Takes as an input uid and returns the list of vehicles owned by the user
// Use as a GET request

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * Servlet implementation class VehiclesList
 */
@WebServlet("/VehiclesList")
public class VehiclesList extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public VehiclesList() {
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
//		String uid = "p1";
//		response.getWriter().print(uid);
//		String all_cars = "select cid, null, null, null from owns where uid = ?";
		String parked_cars = "with parks_tmp as ("
				+ "select cid, pid, entry_time from owns natural left outer join parks where uid = ?) "
				+ "select cid, puid as uid, name as parking_name, pname, start_time, price, entry_time from (select * from parks_tmp natural left outer join parking_mall) "
				+ "as foo natural left outer join (select cid, uid as puid, name as pname, start_time from payer natural join users) as bar";
		//		List<List<Object>> res_all_cars = DbHelper.executeQueryList(all_cars, 
//				new DbHelper.ParamType[] {DbHelper.ParamType.STRING}, 
//				new String[] {uid});
//		List<List<Object>> res_parked_cars = DbHelper.executeQueryList(parked_cars, 
//				new DbHelper.ParamType[] {DbHelper.ParamType.STRING}, 
//				new String[] {uid});
		String res = DbHelper.executeQueryJson(parked_cars, 
				new DbHelper.ParamType[] {DbHelper.ParamType.STRING}, 
				new String[] {uid});
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