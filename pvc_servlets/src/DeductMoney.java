

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Servlet implementation class DeductMoney
 */
@WebServlet("/DeductMoney")
public class DeductMoney extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public DeductMoney() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		System.out.println("het");	
		String deduct = "update wallet w set amount= amount- 50* (select count(*) from payer where payer.uid= w.uid and payer.last_payed+interval '1' hour < now())";
		String res = DbHelper.executeUpdateJson(deduct, 
					new DbHelper.ParamType[] {}, 
					new String[] {});			
	}

}
