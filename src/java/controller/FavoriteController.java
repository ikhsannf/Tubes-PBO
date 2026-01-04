package controller;

import model.Akun;
import service.FavoriteService;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/favorite")
public class FavoriteController extends HttpServlet {

    private FavoriteService service = new FavoriteService();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession();
        Akun user = (Akun) session.getAttribute("user");

        // 1. Cek Login
        if (user == null) {
            resp.setStatus(HttpServletResponse.SC_UNAUTHORIZED); 
            return;
        }

        resp.setContentType("text/plain"); 

        try {
            int filmId = Integer.parseInt(req.getParameter("idFilm"));
            int userId = user.getIdAkun();
            
            // DEBUG: Cek di Output NetBeans apakah ID-nya benar
            System.out.println("[DEBUG] User ID: " + userId + " mencoba like Film ID: " + filmId);

            // 2. Cek Status Saat Ini
            boolean isAlreadyLiked = service.isFavorite(userId, filmId);
            boolean sukses = false;

            if (isAlreadyLiked) {
                // --- PROSES HAPUS (UNLIKE) ---
                sukses = service.removeFavorite(userId, filmId);
                
                if (sukses) {
                    resp.getWriter().write("REMOVED");
                    System.out.println("[SUCCESS] Data berhasil dihapus.");
                } else {
                    // Kalau gagal hapus, kirim error biar tombol tidak berubah
                    resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                    System.out.println("[ERROR] Gagal menghapus data di Database!");
                }
            } else {
                // --- PROSES TAMBAH (LIKE) ---
                sukses = service.addFavorite(userId, filmId);
                
                if (sukses) {
                    resp.getWriter().write("ADDED");
                    System.out.println("[SUCCESS] Data berhasil disimpan.");
                } else {
                    // Kalau gagal simpan, kirim error biar tombol tidak berubah
                    resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                    System.out.println("[ERROR] Gagal menyimpan data! Cek Query INSERT di Service.");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
        }
    }
}