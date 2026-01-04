package controller;

import model.Akun;
import service.AkunService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/login")
public class LoginController extends HttpServlet {
    private final AkunService akunService = new AkunService();

    @Override
    public void init() throws ServletException {
        // Menjalankan pembuatan akun admin saat server startup
        akunService.setupAdminBaru();
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        
        String username = req.getParameter("username"); // admin123
        String password = req.getParameter("password"); // bayaradmin

        // Verifikasi menggunakan BCrypt.checkpw di dalam service
        model.Akun user = akunService.login(username, password);

        if (user != null && "admin".equalsIgnoreCase(user.getRole())) {
            HttpSession session = req.getSession(true);
            session.setAttribute("user", user);
            
            // Langsung arahkan ke CRUD Berita (Halaman Index)
            resp.sendRedirect(req.getContextPath() + "/berita?action=index");
        } else if (user != null) {
            // Jika login sukses tapi bukan admin
            HttpSession session = req.getSession(true);
            session.setAttribute("user", user);
            resp.sendRedirect(req.getContextPath() + "/user/dashboard.jsp");
        } else {
            req.setAttribute("error", "Username atau Password Admin Salah!");
            req.getRequestDispatcher("login.jsp").forward(req, resp);
        }
    }
}