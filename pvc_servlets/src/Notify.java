

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
 * Servlet implementation class Notify
 */
@WebServlet("/Notify")
public class Notify extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public Notify() {
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
		String inspector_uid = (String) request.getParameter("inspector_uid");
		
		String query = "insert into notifications select uid,?,?,null,'1',now(),0 from owns where cid=?";


		String json = DbHelper.executeUpdateJson(query, new DbHelper.ParamType[] { DbHelper.ParamType.STRING,
				DbHelper.ParamType.STRING
				},
				new Object[] {inspector_uid, cid,cid});

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
