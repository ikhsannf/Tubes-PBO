package controller;

import model.Akun;
import service.AkunService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/login")
public class LoginController extends HttpServlet {
    private AkunService akunService = new AkunService();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String username = req.getParameter("username");
        String password = req.getParameter("password");

        Akun user = akunService.login(username, password);

        if (user != null) {
            // Login sukses, simpan user ke session
            HttpSession session = req.getSession();
            session.setAttribute("user", user);
            resp.sendRedirect("user/dashboard.jsp"); // Arahkan ke halaman utama
        } else {
            // Login gagal, tampilkan pesan error
            req.setAttribute("error", "Username atau password salah.");
            req.getRequestDispatcher("login.jsp").forward(req, resp);
        }
    }
}
