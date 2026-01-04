package controller;

import model.Film;
import service.FilmService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;
import java.util.stream.Collectors;

import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

@WebServlet("/film")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2,
    maxFileSize = 1024 * 1024 * 10,
    maxRequestSize = 1024 * 1024 * 50
)
public class FilmController extends HttpServlet {

    private FilmService service = new FilmService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        
        String action = req.getParameter("action");
        if (action == null) action = "index";

        // Ambil parameter page untuk navigasi
        int page = 1;
        int limit = 5; // Tampilkan 5 film per halaman
        if (req.getParameter("page") != null) {
            page = Integer.parseInt(req.getParameter("page"));
        }

        switch (action) {
            case "edit":
                try {
                    int id = Integer.parseInt(req.getParameter("id"));
                    Film film = service.getById(id);
                    req.setAttribute("film", film);
                    req.setAttribute("currentPage", page); // Kirim ke edit.jsp
                    req.getRequestDispatcher("admin/film/edit.jsp").forward(req, resp);
                } catch (Exception e) {
                    resp.sendRedirect("film");
                }
                break;

            case "dashboard":
                // Dashboard biasanya menampilkan yang terbaru (tetap pakai logic limit)
                List<Film> latestFilms = service.getAll(); 
                req.setAttribute("list", latestFilms.stream().limit(8).collect(Collectors.toList()));
                req.getRequestDispatcher("admin/dashboard.jsp").forward(req, resp);
                break;

            default: // Index dengan Pagination
                List<Film> films = service.getByPage(page, limit);
                int totalData = service.getTotalCount();
                int totalPages = (int) Math.ceil((double) totalData / limit);

                req.setAttribute("list", films);
                req.setAttribute("currentPage", page);
                req.setAttribute("totalPages", totalPages);
                req.getRequestDispatcher("admin/film/index.jsp").forward(req, resp);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String action = req.getParameter("action");
        String pageParam = req.getParameter("page");
        if (pageParam == null || pageParam.isEmpty()) pageParam = "1";

        // Ambil data form
        String judul = req.getParameter("judul");
        String deskripsi = req.getParameter("deskripsi");
        String tahunStr = req.getParameter("tahun");
        String genreStr = req.getParameter("genre");
        String ratingStr = req.getParameter("rating");
        String castStr = req.getParameter("cast");

        // ... (Logika parsing tahun, genreId, rating, cast tetap sama seperti kodemu) ...
        int tahun = 0; int genreId = 0; double rating = 0.0; String cast = "-";
        try {
            if(tahunStr != null) tahun = Integer.parseInt(tahunStr);
            if(genreStr != null) genreId = Integer.parseInt(genreStr);
            if(ratingStr != null) rating = Double.parseDouble(ratingStr);
            if(castStr != null) cast = castStr;
        } catch(Exception e) {}

        // --- FILE UPLOAD LOGIC (Gunakan kode UUID kamu yang sudah benar) ---
        String fileName = "";
        Part filePart = req.getPart("poster");
        if (filePart != null && filePart.getSize() > 0) {
            String originFileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
            String extension = originFileName.substring(originFileName.lastIndexOf("."));
            fileName = UUID.randomUUID().toString() + extension;
            String uploadPath = getServletContext().getRealPath("/") + "uploads" + File.separator + "posters";
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) uploadDir.mkdirs();
            filePart.write(uploadPath + File.separator + fileName);
        }

        Film f = new Film();
        f.setJudul(judul);
        f.setDeskripsi(deskripsi);
        f.setTahunRilis(tahun);
        f.setGenreId(genreId);
        f.setRating(rating);
        f.setCastFilm(cast);

        if ("insert".equals(action)) {
            f.setPosterUrl(fileName);
            service.insertFilm(f);
            resp.sendRedirect("film?page=1"); // Kembali ke halaman 1 setelah tambah

        } else if ("update".equals(action)) {
            int id = Integer.parseInt(req.getParameter("id"));
            f.setIdFilm(id);
            if (fileName.isEmpty()) {
                f.setPosterUrl(service.getById(id).getPosterUrl());
            } else {
                f.setPosterUrl(fileName);
            }
            service.updateFilm(f);
            resp.sendRedirect("film?page=" + pageParam); // Kembali ke halaman asal

        } else if ("delete".equals(action)) {
            int id = Integer.parseInt(req.getParameter("id"));
            service.deleteFilm(id);
            resp.sendRedirect("film?page=" + pageParam); // Tetap di halaman asal
        }
    }
}