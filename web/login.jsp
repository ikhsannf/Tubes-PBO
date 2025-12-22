<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Login | movINFO</title>
    <style>
        * {
            box-sizing: border-box;
        }
        body {
            margin: 0;
            font-family: Arial, sans-serif;
            background: #ffffff;      /* hilangin hitam */
            height: 100vh;
            overflow: hidden;
        }
        .wrapper {
            display: flex;
            width: 100%;
            height: 100vh;           /* full layar */
        }
        /* panel kiri: form */
        .left {
            flex: 1.1;
            background: #f3f3f3;
            padding: 60px;
            display: flex;
            flex-direction: column;
            justify-content: center;
        }
        /* panel kanan: info movINFO */
        .right {
            flex: 1;
            background: #4B0082;
            color: #fff;
            padding: 60px;
            display: flex;
            flex-direction: column;
            justify-content: center;
        }
        h2 {
            margin: 0 0 24px;
            font-size: 28px;
        }
        .right h1 {
            margin: 0;
            font-size: 30px;
            line-height: 1.3;
        }
        .right p {
            margin-top: 18px;
            line-height: 1.6;
            max-width: 320px;
        }
        .input-group {
            margin-bottom: 14px;
        }
        .input-wrapper {
            border-radius: 999px;
            border: 1px solid #ccc;
            background: #fafafa;
            padding: 10px 18px;
        }
        .input-wrapper input {
            border: none;
            background: transparent;
            width: 100%;
            outline: none;
        }
        .btn-primary {
            width: 100%;
            border-radius: 999px;
            padding: 12px;
            border: 1px solid #b8b8b8;
            background: #dedede;
            cursor: pointer;
            margin-top: 6px;
        }
        .btn-primary:hover {
            background: #cfcfcf;
        }

        /* teks "Belum mempunyai akun? Daftar" di tengah */
        .center-text {
            text-align: center;
            width: 100%;
            margin-top: 16px;
            font-size: 14px;
        }
        .center-text a {
            text-decoration: none;
            font-weight: 600;
            color: #333;
        }

        .error {
            color: red;
            margin-top: 8px;
            font-size: 13px;
        }
    </style>
</head>
<body>
<div class="wrapper">

    <!-- Kiri: form login -->
    <div class="left">
        <h2>Masuk</h2>
        <form action="login" method="post">
            <div class="input-group">
                <div class="input-wrapper">
                    <input type="text" name="username" placeholder="Username" required />
                </div>
            </div>
            <div class="input-group">
                <div class="input-wrapper">
                    <input type="password" name="password" placeholder="Masukan Kata Sandi" required />
                </div>
            </div>

            <button type="submit" class="btn-primary">Masuk</button>

            <!-- teks daftar di tengah -->
            <div class="center-text">
                Belum mempunyai akun?
                <a href="register.jsp">Daftar</a>
            </div>

            <div class="error">${error}</div>
        </form>
    </div>

    <!-- Kanan: branding -->
    <div class="right">
        <h1>movINFO<br/>Sumber Info Film #1 Anda.</h1>
        <p>Akses cepat ke dunia film Anda. Masuk dan dapatkan semua info favorit tanpa batas!</p>
    </div>

</div>
</body>
</html>