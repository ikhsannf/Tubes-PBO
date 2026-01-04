package controller;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/logout")
public class LogoutController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Hapus session
        HttpSession session = req.getSession(false);
        if (session != null) {
            session.invalidate();
        }
        // Redirect ke halaman login
        resp.sendRedirect("login.jsp");
    }
}