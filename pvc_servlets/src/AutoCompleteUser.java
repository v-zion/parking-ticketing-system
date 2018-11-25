

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
 * Servlet implementation class AutoCompleteUser
 */
@WebServlet("/AutoCompleteUser")
public class AutoCompleteUser extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public AutoCompleteUser() {
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
		String substr = request.getParameter("term");
		
		Double latitude = Double.parseDouble(request.getParameter("latitude"));
		Double longitude = Double.parseDouble(request.getParameter("longitude"));
		
		
		
		String query = "select pid as label, location as value, is_street from parking_mall where (pid ilike ? or name ilike ?) and "
		+ "(latitude - ?)*(latitude - ?) + (longitude - ?)*(longitude - ?) < 25";


		String json = DbHelper.executeQueryJson(query, new DbHelper.ParamType[] { DbHelper.ParamType.STRING,
				DbHelper.ParamType.STRING,
				DbHelper.ParamType.DOUBLE,
				DbHelper.ParamType.DOUBLE,
				DbHelper.ParamType.DOUBLE,
				DbHelper.ParamType.DOUBLE,
				},
				new Object[] { substr + "%", substr + "%", latitude, latitude, longitude, longitude});

		ObjectMapper objectMapper = new ObjectMapper();
		Object jsondata = objectMapper.readValue(json, ObjectNode.class);
		response.getWriter().print(((ObjectNode) jsondata).get("data"));
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
