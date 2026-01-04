package controller;

import model.Akun;
import service.AkunService;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/updateProfile")
public class UpdateProfileController extends HttpServlet {

    private AkunService service = new AkunService();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // 1. Ambil session user saat ini
        HttpSession session = req.getSession();
        Akun currentAkun = (Akun) session.getAttribute("user");

        if (currentAkun == null) {
            resp.sendRedirect("login.jsp");
            return;
        }

        // 2. Ambil data baru dari form
        String newUsername = req.getParameter("username");

        // 3. Update ke Database
        boolean isSuccess = service.updateUsername(currentAkun.getIdAkun(), newUsername);

        if (isSuccess) {
            // 4. PENTING: Update juga data di Session agar tampilan langsung berubah
            currentAkun.setUsername(newUsername);
            session.setAttribute("user", currentAkun);
            
            // Balik ke profile
            resp.sendRedirect("user/profile.jsp");
        } else {
            // Jika gagal (misal koneksi error)
            resp.sendRedirect("user/profile.jsp?error=gagal");
        }
    }
}