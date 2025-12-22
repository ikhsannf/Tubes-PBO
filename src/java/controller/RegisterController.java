package controller;

import model.Akun;
import service.AkunService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/register")
public class RegisterController extends HttpServlet {
    private AkunService akunService = new AkunService();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String username = req.getParameter("username");
        String password = req.getParameter("password");
         // Misalnya role: 'user' atau 'admin'

        Akun newUser = new Akun();
        newUser.setUsername(username);
        newUser.setPassword(password);
        

        boolean isRegistered = akunService.register(newUser);

        if (isRegistered) {
            resp.sendRedirect("login.jsp"); // Redirect ke login setelah registrasi sukses
        } else {
            req.setAttribute("error", "Registrasi gagal.");
            req.getRequestDispatcher("register.jsp").forward(req, resp); // Kembali ke halaman registrasi dengan pesan error
        }
    }
}
