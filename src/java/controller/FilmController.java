package controller;

import model.Film;
import service.FilmService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;
import java.util.stream.Collectors;

@WebServlet("/film")
public class FilmController extends HttpServlet {

    private FilmService service = new FilmService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String action = req.getParameter("action");

        if (action == null) action = "index";

        switch (action) {

            case "add":
                req.getRequestDispatcher("admin/film/add.jsp").forward(req, resp);
                break;

            case "edit":
                int id = Integer.parseInt(req.getParameter("id"));
                Film film = service.getById(id);

                req.setAttribute("film", film);
                req.getRequestDispatcher("admin/film/edit.jsp").forward(req, resp);
                break;
                
            case "dashboard":
                // Ambil 8 film terbaru dari DB
                List<Film> allFilms = service.getAll();
                List<Film> latestFilms = allFilms.stream()
                    .sorted((f1, f2) -> Integer.compare(f2.getIdFilm(), f1.getIdFilm()))
                    .limit(8)
                    .collect(Collectors.toList());
                req.setAttribute("list", latestFilms);
                req.getRequestDispatcher("admin/dashboard.jsp").forward(req, resp);
                break;

            default: // index
                List<Film> films = service.getAll();
                req.setAttribute("list", films);
                req.getRequestDispatcher("admin/film/index.jsp").forward(req, resp);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String action = req.getParameter("action");

        if ("insert".equals(action)) {

            Film f = new Film();
            f.setJudul(req.getParameter("judul"));
            f.setDeskripsi(req.getParameter("deskripsi"));
            f.setTahunRilis(Integer.parseInt(req.getParameter("tahun")));
            f.setGenreId(Integer.parseInt(req.getParameter("genre")));
            f.setPosterUrl(req.getParameter("poster"));
            

            service.insert(f);
            resp.sendRedirect("film");

        } else if ("update".equals(action)) {

            Film f = new Film();
            f.setIdFilm(Integer.parseInt(req.getParameter("id")));
            f.setJudul(req.getParameter("judul"));
            f.setDeskripsi(req.getParameter("deskripsi"));
            f.setTahunRilis(Integer.parseInt(req.getParameter("tahun")));
            f.setGenreId(Integer.parseInt(req.getParameter("genre")));
            f.setPosterUrl(req.getParameter("poster"));

            service.update(f);
            resp.sendRedirect("film");

        } else if ("delete".equals(action)) {

            int id = Integer.parseInt(req.getParameter("id"));
            service.delete(id);
            resp.sendRedirect("film");
        }
    }
}
