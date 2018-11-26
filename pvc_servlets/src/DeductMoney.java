

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
		String deduct = "with mytable(uid,price)  as (select uid,coalesce(sum(price),0) from (select cid,uid,pid from payer natural join parks where "
				+ "last_payed+interval '1' hour < now()) "
				+ "as foo join (select pid, price from parking_mall) as bar using(pid) group by uid)"
				+ "update wallet w set amount = amount - (select price from mytable where uid = w.uid) where exists(select price from mytable where uid = w.uid)";
		
		String adder = "with mytable(uid,price)  as (select uid,coalesce(sum(price),0) from"
		+ "(select cid,pid from payer natural join parks where last_payed+interval '1' hour < now()) as foo "
		+ "natural join parking_mall group by uid)"
		+ "update wallet w set amount = amount + (select price from mytable where uid = w.uid) where exists(select price from mytable where uid = w.uid)";
		
		String payerUpdate= "update payer set last_payed = last_payed+interval '1' hour where payer.last_payed+interval '1' hour < now()";
		String res = DbHelper.executeUpdateJson(deduct, 
					new DbHelper.ParamType[] {}, 
					new String[] {});
		
		String res3 = DbHelper.executeUpdateJson(adder, 
				new DbHelper.ParamType[] {}, 
				new String[] {});
		
		
		String res1 = DbHelper.executeUpdateJson(payerUpdate, 
				new DbHelper.ParamType[] {}, 
				new String[] {});
		
		String querynotify = "insert into notifications select uid,null,null,amount,'2',now(),0 from users natural join wallet where amount<100";
		String res2 = DbHelper.executeUpdateJson(querynotify, 
				new DbHelper.ParamType[] {}, 
				new String[] {});
	}

}
