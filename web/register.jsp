<style>
    * {
        box-sizing: border-box;
    }
    body {
        margin: 0;
        font-family: Arial, sans-serif;
        background: #ffffff; /* hilangkan hitam */
        height: 100vh;
        overflow: hidden;
    }

    .wrapper {
        display: flex;
        width: 100%;
        height: 100vh; /* full layar */
    }
    
    .center-text {
    text-align: center;
    width: 100%;
    margin-top: 14px;
    font-size: 14px;
}


    /* Panel kiri */
    .left {
        flex: 1;
        background: #4B0082;
        color: #fff;
        padding: 60px;
        display: flex;
        flex-direction: column;
        justify-content: center;
        border-radius: 0; /* hilangkan rounded supaya full */
    }

    .left h1 {
        font-size: 36px;
        margin: 0;
        line-height: 1.3;
    }

    .left p {
        margin-top: 20px;
        width: 300px;
        line-height: 1.6;
        opacity: .95;
    }

    /* Panel kanan */
    .right {
        flex: 1.1;
        background: #f3f3f3;
        padding: 60px;
        display: flex;
        flex-direction: column;
        justify-content: center;
    }

    .right h2 {
        font-size: 28px;
        margin: 0 0 26px;
    }

    .input-group {
        margin-bottom: 14px;
    }

    .input-wrapper {
        display: flex;
        align-items: center;
        border-radius: 999px;
        border: 1px solid #cfcfcf;
        background: #fafafa;
        padding: 10px 18px;
    }

    .input-wrapper i {
        margin-right: 10px;
        font-size: 14px;
        color: #555;
    }

    .input-wrapper input {
        border: none;
        background: transparent;
        flex: 1;
        outline: none;
    }

    .btn-primary {
        width: 100%;
        border-radius: 999px;
        padding: 12px;
        font-size: 14px;
        font-weight: bold;
        border: 1px solid #bbb;
        background: #ddd;
        cursor: pointer;
        margin-top: 6px;
    }
    .btn-primary:hover {
        background: #c8c8c8;
    }

    .small-text {
        font-size: 13px;
        margin-top: 10px;
    }

    .small-text a {
        font-weight: bold;
        text-decoration: none;
        color: #333;
    }

    .or-text {
        font-size: 13px;
        margin-top: 14px;
    }

    .social {
        margin-top: 12px;
        display: flex;
        gap: 14px;
    }

    .social button {
        width: 40px;
        height: 40px;
        border-radius: 50%;
        border: 1px solid #ccc;
        background: #fff;
        cursor: pointer;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 16px;
    }

    .error {
        color: red;
        margin-top: 8px;
        font-size: 13px;
    }
</style>

<body>
<div class="wrapper">

    <div class="left">
        <h1>movINFO<br/>Sumber Info Film #1 Anda.</h1>
        <p>Daftar sekarang dan rasakan pengalaman membaca info film yang lebih personal.</p>
    </div>

    <div class="right">
        <h2>Daftar Akun</h2>
        <form action="register" method="post">
            <div class="input-group">
                <div class="input-wrapper">
                    <i class="fa-regular fa-envelope"></i>
                    <input type="email" name="email" placeholder="Masukkan Email" required />
                </div>
            </div>

            <div class="input-group">
                <div class="input-wrapper">
                    <i class="fa-regular fa-user"></i>
                    <input type="text" name="username" placeholder="Username" required />
                </div>
            </div>

            <div class="input-group">
                <div class="input-wrapper">
                    <i class="fa-solid fa-lock"></i>
                    <input type="password" name="password" placeholder="Buat Kata Sandi" required />
                </div>
            </div>

            <button type="submit" class="btn-primary">Daftar Akun</button>

            <div class="center-text">
              Sudah mempunyai akun? <a href="login.jsp">Masuk</a>
            </div>


            <div class="error">${error}</div>
        </form>
    </div>

</div>
</body>