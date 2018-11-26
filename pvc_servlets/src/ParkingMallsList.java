

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ObjectNode;

/**
 * Servlet implementation class ParkingMallsList
 */
@WebServlet("/ParkingMallsList")
public class ParkingMallsList extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public ParkingMallsList() {
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
		
		String uid = session.getAttribute("id").toString();
				
		
		String query = "select * from (select uid, name as uname from users) as bar "
				+ "join (select * from parking_mall natural join parking_floor) as foo using (uid) where uid = ? order by pid";


		String json = DbHelper.executeQueryJson(query, new DbHelper.ParamType[] { DbHelper.ParamType.STRING,
				},
				new Object[] {uid});

		ObjectMapper objectMapper = new ObjectMapper();
		Object jsondata = objectMapper.readValue(json, ObjectNode.class);
		response.getWriter().print(((ObjectNode) jsondata));
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
