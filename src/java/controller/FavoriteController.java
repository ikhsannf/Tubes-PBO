package controller;

import model.Favorite;
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

        if (user == null) {
            resp.sendRedirect("login.jsp");
            return;
        }

        int filmId = Integer.parseInt(req.getParameter("filmId"));

        Favorite fav = new Favorite();
        fav.setIdUser(user.getIdAkun());
        fav.setIdFilm(filmId);

        service.addFavorite(fav.getIdUser(), fav.getIdFilm());
        resp.sendRedirect("user/film.jsp");
    }
}
