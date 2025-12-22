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

        if (user == null) {
            resp.sendRedirect("login.jsp");
            return;
        }

        int beritaId = Integer.parseInt(req.getParameter("beritaId"));

        LikeBerita like = new LikeBerita();
        like.setIdAkun(user.getIdAkun());
        like.setIdBerita(beritaId);

        service.like(like.getIdAkun(), like.getIdBerita());
        resp.sendRedirect("user/berita.jsp");
    }
}
