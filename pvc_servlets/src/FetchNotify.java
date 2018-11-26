

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
 * Servlet implementation class FetchNotify
 */
@WebServlet("/FetchNotify")
public class FetchNotify extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public FetchNotify() {
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
		String uid = (String) session.getAttribute("id");
		
		String query = "select * from notifications where person_uid = ? order by time desc";
		String json = DbHelper.executeQueryJson(query, new DbHelper.ParamType[] { DbHelper.ParamType.STRING,
				},
				new Object[] {uid});
		
		
		String query1 = "update notifications set read = 1 where person_uid=?";
		String json1 = DbHelper.executeUpdateJson(query1, new DbHelper.ParamType[] { DbHelper.ParamType.STRING,
				},
				new Object[] {uid});
		
		System.out.println(json);

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
