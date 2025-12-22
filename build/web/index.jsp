<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>movINFO | Landing Page</title>
    <style>
        * {
            box-sizing: border-box;
        }
        body {
            margin: 0;
            font-family: Arial, sans-serif;
            background: #ffffff;
            height: 100vh;
            overflow: hidden;
        }

        /* Container full */
        .page {
            width: 100%;
            height: 100vh;
            background: #f3f3f3;
            padding: 32px 64px;
            display: flex;
            flex-direction: column;
        }

        /* TOP BAR */
        .topbar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 32px;
        }
        .logo-badge {
            display: inline-flex;
            align-items: center;
            padding: 6px 18px;
            border-radius: 999px;
            background: #4B0082;
            color: #fff;
            font-weight: bold;
            font-size: 14px;
        }
        .logo-badge span {
            margin-left: 4px;
            font-weight: 600;
        }
        .btn-signin {
            padding: 8px 22px;
            border-radius: 999px;
            border: none;
            cursor: pointer;
            background: #4B0082;
            color: #fff;
            font-size: 13px;
            font-weight: 600;
        }

        /* MAIN CONTENT */
        .content {
            flex: 1;
            display: flex;
            gap: 40px;
            align-items: center;
        }

        /* KIRI */
        .left {
            flex: 1;
        }
        .headline {
            font-size: 44px;
            font-weight: 800;
            color: #3a0070;
            line-height: 1.15;
            margin-bottom: 18px;
        }
        .desc {
            font-size: 14px;
            line-height: 1.7;
            max-width: 420px;
            color: #444;
            margin-bottom: 26px;
        }
        .btn-cta {
            padding: 10px 28px;
            border-radius: 999px;
            border: none;
            background: #4B0082;
            color: #fff;
            font-weight: 600;
            cursor: pointer;
            font-size: 14px;
        }

        /* KANAN */
        .right {
            flex: 1;
            display: flex;
            justify-content: center;
        }
        .card {
            width: 380px;
            height: 430px;
            background: #4B0082;
            border-radius: 36px;
            padding: 26px;
            display: flex;
            flex-direction: column;
            align-items: center;
        }

        .poster {
            width: 100%;
            height: 300px;
            border-radius: 24px;
            overflow: hidden;
            background: #000;
            position: relative;
        }
        .poster img {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            object-fit: cover;
            opacity: 0;
            transition: opacity 0.6s ease;
        }
        .poster img.active {
            opacity: 1;
        }

        .dots {
            margin-top: 16px;
            display: flex;
            gap: 8px;
            justify-content: center;
        }
        .dot {
            width: 10px;
            height: 10px;
            border-radius: 50%;
            background: #d6c4ff;
            cursor: pointer;
        }
        .dot.active {
            background: #ffffff;
        }

        a {
            text-decoration: none;
        }

        /* responsive simple */
        @media (max-width: 900px) {
            body {
                overflow: auto;
            }
            .page {
                padding: 24px 20px;
                height: auto;
            }
            .content {
                flex-direction: column;
                align-items: flex-start;
            }
            .right {
                width: 100%;
                justify-content: flex-start;
            }
            .card {
                width: 100%;
            }
        }
    </style>
</head>
<body>

<div class="page">

    <!-- TOP BAR -->
    <div class="topbar">
        <div class="logo-badge">
            mov<span>INFO</span>
        </div>

        <a href="login.jsp">
            <button class="btn-signin">Sign In</button>
        </a>
    </div>

    <!-- MAIN CONTENT -->
    <div class="content">
        <!-- LEFT -->
        <div class="left">
            <div class="headline">
                Sumber Info<br/>
                Film #1 Anda.
            </div>

            <div class="desc">
                Platform berita yang menyajikan informasi film real-time,
                memberikan Anda update terakurat, ulasan terpercaya, dan
                jadwal tayang yang Anda butuhkan, segera.
            </div>

            <a href="register.jsp">
                <button class="btn-cta">Daftar Sekarang</button>
            </a>
        </div>

        <!-- RIGHT -->
        <div class="right">
            <div class="card">
                <div class="poster">
            
                    <img src="gambar/ranggacinta.jpg" alt="Poster 1" class="slide active">
                    <img src="gambar/avatar.jpg" alt="Poster 2" class="slide">
                    <img src="gambar/zootopia.jpg" alt="Poster 3" class="slide">
                </div>

                <div class="dots">
                    <div class="dot active" data-index="0"></div>
                    <div class="dot" data-index="1"></div>
                    <div class="dot" data-index="2"></div>
                </div>
            </div>
        </div>
    </div>

</div>

<script>
  
    const slides = document.querySelectorAll('.slide');
    const dots   = document.querySelectorAll('.dot');
    let current  = 0;
    let timer;

    function showSlide(index) {
 
        if (index < 0) index = slides.length - 1;
        if (index >= slides.length) index = 0;

        // ganti kelas active
        slides.forEach(s => s.classList.remove('active'));
        dots.forEach(d => d.classList.remove('active'));

        slides[index].classList.add('active');
        dots[index].classList.add('active');

        current = index;
    }

    function startAutoSlide() {
        timer = setInterval(function () {
            showSlide(current + 1);
        }, 3000); // 3 detik
    }


    dots.forEach(dot => {
        dot.addEventListener('click', function () {
            clearInterval(timer);
            const idx = parseInt(this.getAttribute('data-index'));
            showSlide(idx);
            startAutoSlide(); 
    });

    // mulai
    startAutoSlide();
</script>

</body>
</html>