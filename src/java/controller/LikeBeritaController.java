package controller;

import model.LikeBerita;
import model.Akun;
import service.LikeBeritaService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/like")
public class LikeBeritaController extends HttpServlet {

    private LikeBeritaService service = new LikeBeritaService();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession();
        Akun user = (Akun) session.getAttribute("user");

        // 1. Cek Login
        if (user == null) {
            // Jika belum login, arahkan ke login.jsp (asumsi login.jsp ada di luar/root)
            resp.sendRedirect(req.getContextPath() + "/login.jsp"); 
            return;
        }

        // 2. Ambil Data
        int beritaId = Integer.parseInt(req.getParameter("beritaId"));
        int userId = user.getIdAkun();

        // 3. LOGIKA TOGGLE (BOLAK-BALIK)
        // Cek apakah user sudah like sebelumnya?
        boolean isLiked = service.isLiked(userId, beritaId);
        String status = "";

        if (isLiked) {
            service.unlike(userId, beritaId); // Hapus like
            status = "UNLIKED";
        } else {
            service.like(userId, beritaId);   // Tambah like
            status = "LIKED";
        }

        // 4. Hitung Total Likes Terbaru
        int newCount = service.getLikesByBerita(beritaId).size();

        // 5. Kirim Response ke Client (AJAX)
        resp.setContentType("text/plain");
        resp.getWriter().write(status + ":" + newCount);
    }
}