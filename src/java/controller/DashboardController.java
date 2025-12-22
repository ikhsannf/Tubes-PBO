package controller;

import model.Film;
import service.FilmService;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;
import java.util.stream.Collectors;

@WebServlet("/dashboard")
public class DashboardController extends HttpServlet {
    
    private FilmService filmService = new FilmService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) 
            throws ServletException, IOException {
        
        try {
            // Ambil 8 film terbaru (berdasarkan ID terbesar)
            List<Film> allFilms = filmService.getAll();
            List<Film> latestFilms = allFilms.stream()
                .sorted((f1, f2) -> Integer.compare(f2.getIdFilm(), f1.getIdFilm()))
                .limit(8)
                .collect(Collectors.toList());
            
            req.setAttribute("list", latestFilms);
            
        } catch (Exception e) {
            // Log error dan set empty list jika gagal
            e.printStackTrace();
            req.setAttribute("list", java.util.Collections.emptyList());
        }
        
        // Forward ke dashboard.jsp
        req.getRequestDispatcher("admin/dashboard.jsp").forward(req, resp);
    }
}