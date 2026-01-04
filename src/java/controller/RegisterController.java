package controller;

import service.AkunService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/register")
public class RegisterController extends HttpServlet {

    private final AkunService akunService = new AkunService();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String email = req.getParameter("email");
        String username = req.getParameter("username");
        String password = req.getParameter("password");

        int result = akunService.register(email, username, password);

        if (result == AkunService.REGISTER_SUCCESS) {
            // Sukses, arahkan ke login dengan pesan sukses (opsional simpan di session)
            resp.sendRedirect("login.jsp");
            return;
        }

        // Handle Error
        if (result == AkunService.REGISTER_DUPLICATE) {
            req.setAttribute("error", "Email atau username sudah terdaftar.");
        } else if (result == AkunService.REGISTER_INVALID_USERNAME) {
            req.setAttribute("error", "Username tidak boleh mengandung spasi/kosong.");
        } else if (result == AkunService.REGISTER_INVALID_PASSWORD) {
            req.setAttribute("error", "Password minimal 8 karakter.");
        } else {
            req.setAttribute("error", "Registrasi gagal.");
        }

        req.getRequestDispatcher("register.jsp").forward(req, resp);
    }
}