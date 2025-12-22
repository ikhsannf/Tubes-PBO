package controller;

import model.Genre;
import service.GenreService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/genre")
public class GenreController extends HttpServlet {

    private GenreService service = new GenreService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String action = req.getParameter("action");
        if (action == null) action = "index";

        switch (action) {

            case "add":
                req.getRequestDispatcher("admin/genre/add.jsp").forward(req, resp);
                break;

            case "edit":
                int id = Integer.parseInt(req.getParameter("id"));
                Genre g = service.getById(id);
                req.setAttribute("genre", g);
                req.getRequestDispatcher("admin/genre/edit.jsp").forward(req, resp);
                break;

            default:
                List<Genre> list = service.getAll();
                req.setAttribute("list", list);
                req.getRequestDispatcher("admin/genre/index.jsp").forward(req, resp);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String action = req.getParameter("action");

        if ("insert".equals(action)) {
            Genre g = new Genre();
            g.setNamaGenre(req.getParameter("nama"));
            service.insert(g);
            resp.sendRedirect("genre");

        } else if ("update".equals(action)) {
            Genre g = new Genre();
            g.setIdGenre(Integer.parseInt(req.getParameter("id")));
            g.setNamaGenre(req.getParameter("nama"));
            service.update(g);
            resp.sendRedirect("genre");

        } else if ("delete".equals(action)) {
            int id = Integer.parseInt(req.getParameter("id"));
            service.delete(id);
            resp.sendRedirect("genre");
        }
    }
}
