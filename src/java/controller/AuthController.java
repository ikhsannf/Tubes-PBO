package controller;

import model.Akun;
import service.AkunService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/auth")
public class AuthController extends HttpServlet {

    private AkunService service = new AkunService();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String action = req.getParameter("action");

        if ("login".equals(action)) {
            String username = req.getParameter("username");
            String password = req.getParameter("password");

            Akun user = service.login(username, password);

            if (user == null) {
                req.setAttribute("error", "Username atau password salah!");
                req.getRequestDispatcher("login.jsp").forward(req, resp);
                return;
            }

            HttpSession session = req.getSession();
            session.setAttribute("user", user);

            if ("admin".equals(user.getRole())) {
                resp.sendRedirect("admin/dashboard.jsp");
            } else {
                resp.sendRedirect("user/home.jsp");
            }
        }

        else if ("logout".equals(action)) {
            req.getSession().invalidate();
            resp.sendRedirect("login.jsp");
        }
    }
}
